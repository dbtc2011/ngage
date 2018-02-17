//
//  FBShareTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 11/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import FacebookShare
import FacebookCore
import WebKit

class FBShareTaskViewController: UIViewController {
    
    var mission : MissionModel!
    var task : TaskModel!
    var user = UserModel().mainUser()
    var urlLink : URL!

    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
//        let color = UIColor().setColorUsingHex(hex: mission.colorBackground)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Function
    func setupUI() {
      
    }
    
    func getData() {
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            if let result = result {
                if let contents = result["content"].array {
//                    for content in contents {
//                        let questionaire = QuestionsModel(info: content)
//                        self.questions.append(questionaire)
//                    }
                    if let dictionary = contents[0].dictionary {
                        var urlString = dictionary["URL"]?.string ?? ""
                        urlString = urlString.replacingOccurrences(of: "http", with: "https")
                        if let url = URL(string: urlString) {
                            self.urlLink = url
                            self.webview.load(URLRequest(url: url))
                            self.webview.allowsBackForwardNavigationGestures = true
                        }
                    }
                    
                }
                
            }
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
    @IBAction func didTapBack(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapShare(_ sender: UIBarButtonItem) {
        
        let content = LinkShareContent(url: urlLink)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = ShareDialogMode.native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        
        do {
            try shareDialog.show()
        } catch {
            print("Cannot show dialog")
        }
        
    }
    
    
}
