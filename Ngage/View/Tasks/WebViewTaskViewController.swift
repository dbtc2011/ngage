//
//  WebViewTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 04/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import WebKit
protocol TaskDoneDelegate {
    func didFinishedTask(task: TaskModel)
}
class WebViewTaskViewController: UIViewController {
    
    var webLink: String!
    var mission: MissionModel!
    var task : TaskModel!
    var user = UserModel().mainUser()
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var delegate : TaskDoneDelegate?
    
    
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
        labelTask.text = task.info
        print("URL = \(webLink)")
        if let url = URL(string: webLink) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            webView.navigationDelegate = self
        }
    }

    func finishedTask() {
        delegate?.didFinishedTask(task: task)
        _ = navigationController?.popViewController(animated: true) as? TaskViewController 
            
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}

extension WebViewTaskViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
        print("NAVIGATION WEBVIEW")
        
        if let url = navigationResponse.response.url {
            if url.absoluteString.contains("ph.yahoo.com") {
                finishedTask()
            }
        }
    }
    
}


