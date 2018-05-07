//
//  InstallTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 18/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import KYDrawerController

class InstallTaskViewController: MainViewController {

    var user = UserModel().mainUser()
    var task : TaskModel!
    var mission : MissionModel!
    var didOpenUrl = false
    var installDelegate : TaskDoneDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        showSpinner()
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            if error != nil {
                self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
            } else {
                guard let contents = result?["content"].array, contents.count > 0, let dictionaryData = contents[0].dictionary, let stringLink = dictionaryData["ContentData"]?.string , let url = URL(string: stringLink) else {
                    self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
                    return
                }
                self.didOpenUrl = true
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func didInstall() {
        DispatchQueue.main.async {
            self.hideSpinner()
            self.installDelegate?.didFinishedTask(task: self.task)
            _ = self.navigationController?.popViewController(animated: false)
        }
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

