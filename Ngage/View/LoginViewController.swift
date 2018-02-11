//
//  LoginViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class LoginViewController: UIViewController {

    var user : UserModel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var buttonOK: UIButton!
    @IBOutlet weak var buttonReferral: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupView() {
        name.text = user.name
        email.text = user.emailAddress
        buttonOK.layer.cornerRadius = 10
        buttonReferral.layer.cornerRadius = 10
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ReferralCodeViewController {
            
            controller.delegate = self
            controller.user = self.user
            
        }else if let controller = segue.destination as? MSISDNViewController {
            controller.user = self.user
        }
 
    }
 
    
    //MARK: - Button Action
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMSISDN", sender: self)
    }
    
    @IBAction func referralButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToReferral", sender: self)
    }
}

extension LoginViewController : ReferralCodeViewControllerDelegate {
    
    func didEnterReferredBy(value: String) {
        self.user.refferedBy = value
    }
}



