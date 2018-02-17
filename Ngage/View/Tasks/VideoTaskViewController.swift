//
//  VideoTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 17/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import AVKit

class VideoTaskViewController: UIViewController {
    var currentPath = ""
    let user = UserModel().mainUser()
    var mission : MissionModel!
    var task : TaskModel!
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer!
    var timeObserver : AnyObject!
    
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var playerContainer: UIView!
    var playerRateBeforeSeek: Float = 0
    
    
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
    

    func playVideo() {
        var fileURL = currentPath.replacingOccurrences(of: "http", with: "https")
        fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: fileURL) {
            let playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: playerItem)
            self.player!.play()
        
            let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
            timeObserver = self.player!.addPeriodicTimeObserver(forInterval: timeInterval,
                                                                       queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
                                                                        self.observeTime(elapsedTime: elapsedTime)
                                                                        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
                                                                        let maxTime : Float64 = CMTimeGetSeconds(self.player!.currentItem!.duration)
                                                                        self.playerSlider.maximumValue = Float(maxTime)
                                                                        self.playerSlider.value = Float ( time )
                                                                        print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
                } as AnyObject
            setupUI()
            
        }else {
            print("URL not playable ----> \(fileURL)")
        }
    }
    func getData() {
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            if let result = result {
                print("Result = \(result)")
                if let content = result["content"].array {
                    if let dictionaryContent = content[0].dictionary {
                        self.currentPath = dictionaryContent["ContentData"]?.string ?? ""
                        self.playVideo()
                    }
                }
            }
        }
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        
        let timeRemaining: Float64 = CMTimeGetSeconds(self.player!.currentItem!.duration) - elapsedTime
        labelTimer.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        playerSlider.value = Float(elapsedTime)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(self.player!.currentItem!.duration)
        let elapsedTime = CMTimeGetSeconds(elapsedTime)
        updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
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
