//
//  WebViewTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 04/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import WebKit
class WebViewTaskViewController: UIViewController {
    
    var webLink: String!
    var mission: MissionModel!
    var task : TaskModel!
    var user = UserModel().mainUser()
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        labelTask.text = task.info ?? ""
        print("URL = \(webLink)")
        if let url = URL(string: webLink) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
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
    @IBAction func backButtonClicked(_ sender: UIButton) {
    }
    
}

extension WebViewTaskViewController : WKNavigationDelegate {
    
    
    
}


