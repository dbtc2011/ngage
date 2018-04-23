//
//  DrawerWebViewController.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 04/03/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import WebKit

class DrawerWebViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var webLink : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     @IBAction func aboutUsClicked(_ sender: UIButton) {
     delegate?.profileDidSelect(link: "about_us")
     }
     
     @IBAction func faqsButtonClicked(_ sender: UIButton) {
     delegate?.profileDidSelect(link: "faqs")
     }
     
     @IBAction func termsButtonClicked(_ sender: UIButton) {
     delegate?.profileDidSelect(link: "terms")
     }
     
     @IBAction func reloadButtonClicked(_ sender: UIButton) {
     delegate?.profileShouldGetPoints(withCell: self)
     }
     
     @IBAction func privacyButtonClicked(_ sender: UIButton) {
     delegate?.profileDidSelect(link: "privacy")
     }
 */
    func setupUI() {
        print("URL = \(webLink)")
        if webLink.contains("privacy_policy") {
            labelTitle.text = "Privacy Policy"
        }else if webLink.contains("faq") {
            labelTitle.text = "FAQs"
        }else if webLink.contains("tos_ngage") {
            labelTitle.text = "Terms and Conditions"
        }
        if let url = URL(string: webLink) {
            webView.load(URLRequest(url: url))
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
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        view.window!.layer.add(transition, forKey: kCATransition)
//        dismiss(animated: false, completion: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
}
