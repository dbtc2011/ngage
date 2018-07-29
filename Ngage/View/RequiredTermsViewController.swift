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
  var selectedIndex = 0
  var links = ["https://ngage.ph/tos_ngage.html", "https://ngage.ph/privacy_policy_ngage.html"]
  
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var labelTitle: UILabel!
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
    if selectedIndex == 0 {
      labelTitle.text = "Terms and Conditions"
    } else {
      labelTitle.text = "Privacy Policy"
    }
    if let url = URL(string: links[selectedIndex]) {
      webView.load(URLRequest(url: url))
    }
    
  }
  
  //MARK: - Button Actions
  @IBAction func didTapBack(_ sender: UIButton) {
    self.dismiss(animated: false) {
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
