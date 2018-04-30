//
//  RequiredTermsViewController.swift
//  Ngage PH
//
//  Created by Stratpoint on 30/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import WebKit

class RequiredTermsViewController: MainViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonAgree: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttonDisagree: UIButton!
    var links = ["https://ngage.ph/tos_ngage.html", "https://ngage.ph/privacy_policy_ngage.html"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        buttonDisagree.isHidden = true
        labelTitle.text = "Terms and Conditions"
        if let url = URL(string: links[0]) {
            webView.load(URLRequest(url: url))
        }
        buttonAgree.setTitle("CONTINUE", for: UIControlState.normal)
    }
    
    //MARK: - Button Actions
    @IBAction func didTapAgree(_ sender: UIButton) {
        if sender.title(for: UIControlState.normal) == "CONTINUE" {
            labelTitle.text = "Privacy Policy"
            buttonDisagree.isHidden = false
            buttonAgree.setTitle("AGREE", for: UIControlState.normal)
            if let url = URL(string: links[1]) {
                webView.load(URLRequest(url: url))
            }
            
        }else {
            self.dismiss(animated: false) {
                
            }
        }
        
    }
    
    @IBAction func didTapDisagree(_ sender: UIButton) {
        self.presentDefaultAlertWithMessage(message: "Accept the Privacy Policy to continue using the app.")
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
