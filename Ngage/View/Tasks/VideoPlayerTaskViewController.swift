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
        fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: fileURL) {
            self.player = AVPlayer(url: url)
            self.player!.play()
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
    
}

extension VideoPlayerTaskViewController : AVPlayerViewControllerDelegate {
    
}
