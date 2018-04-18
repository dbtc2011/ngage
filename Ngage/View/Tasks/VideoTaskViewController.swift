//
//  VideoTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 17/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import AVKit

class VideoTaskViewController: MainViewController {
    //MARK: - Properties
    var currentPath = ""
    let user = UserModel().mainUser()
    var mission : MissionModel!
    var task : TaskModel!
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer!
    var timeObserver : AnyObject!
    var audioTimer: Timer?
    
    var audioDuration = 0.0
    var currentTime = 0.0
    
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var playerContainer: UIView!
    var playerRateBeforeSeek: Float = 0
    
    var contentID : String = ""
    var contentDuration : String = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupUI() {
        playerSlider.isUserInteractionEnabled = false
        playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = playerContainer.bounds
        playerContainer.layer.insertSublayer(playerLayer, at: 0)
    }
    

    //MARK: - Function
    func playVideo() {
        var fileURL = currentPath.replacingOccurrences(of: "http", with: "https")
        fileURL = fileURL.replacingOccurrences(of: "httpss", with: "https")
        fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: fileURL) {
            
            let asset = AVURLAsset(url: url)
            audioDuration = CMTimeGetSeconds(asset.duration)
            let playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: playerItem)
            self.player!.play()
            self.playerSlider.minimumValue = 0
            self.playerSlider.maximumValue = Float(audioDuration)
            enableTimer()
            setupUI()
            self.hideSpinner()
            
        }else {
            self.hideSpinner()
            print("URL not playable ----> \(fileURL)")
        }
    }
    
    //MARK: - Timer
    private func enableTimer() {
        disableTimer()
        audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }
    
    private func disableTimer() {
        guard audioTimer != nil else { return }
        
        audioTimer!.invalidate()
        audioTimer = nil
    }
    
    @objc func timerDidFire() {
        updateTimeLabel()
    }
    func getData() {
        showSpinner()
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            
            if let result = result {
                print("Result = \(result)")
                if let content = result["content"].array {
                    if let dictionaryContent = content[0].dictionary {
                        self.currentPath = dictionaryContent["ContentData"]?.string ?? ""
                        self.contentID = dictionaryContent["ContentID"]?.string ?? ""
                        self.playVideo()
                    }else {
                        self.hideSpinner()
                    }
                }else {
                    self.hideSpinner()
                }
            }else {
                self.hideSpinner()
            }
        }
    }
    
    private func updateTimeLabel() {
        let timeTotal: Float64 = CMTimeGetSeconds(self.player!.currentItem!.duration)
        let timeCurrent: Float64 = CMTimeGetSeconds(self.player!.currentItem!.currentTime())
        let timeRemaining = timeTotal - timeCurrent
        labelTimer.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        playerSlider.value = Float(timeCurrent)
        if labelTimer.text == "00:00" {
            print("Should stop")
            if let controller = navigationController?.viewControllers[1] as? TaskViewController {
                _ = navigationController?.popToViewController(controller, animated: true)
                controller.setContent(id: contentID, duration: contentDuration)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if player != nil {
            player!.play()
        }
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    override var shouldAutorotate: Bool {
        
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
