//
//  VideoPlayerTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 11/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import PKHUD

class VideoPlayerTaskViewController: AVPlayerViewController {
    var currentPath = ""
    let user = UserModel().mainUser()
    var mission : MissionModel!
    var task : TaskModel!
    override func viewDidLoad() {
        
        getData()
    }
    
    func setup() {
        
    }
    
    func playVideo() {
        var fileURL = currentPath.replacingOccurrences(of: "http", with: "https")
        fileURL = fileURL.replacingOccurrences(of: "httpss", with: "https")
        fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: fileURL) {
            self.player = AVPlayer(url: url)
            self.player!.play()
        }else {
            print("URL not playable ----> \(fileURL)")
        }
    }
    func getData() {
        showSpinner()
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            self.hideSpinner()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func showSpinner() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        
        let imageBG = UIImage(named: "bg_loader")
        //        PKHUD.sharedHUD.contentView = loaderBG()
        
        if !PKHUD.sharedHUD.isVisible {
            PKHUD.sharedHUD.show()
        }
    }
    
    func hideSpinner() {
        if PKHUD.sharedHUD.isVisible {
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide(afterDelay: 0.0) { success in
                    // Completion Handler
                }
            }
        }
    }
    
}

extension VideoPlayerTaskViewController : AVPlayerViewControllerDelegate {
    
}
