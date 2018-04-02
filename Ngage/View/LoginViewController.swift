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
    @IBOutlet weak var imgProfile: UIImageView!
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func setupView() {
        name.text = user.name
        email.text = user.emailAddress
        buttonOK.layer.cornerRadius = 27
        buttonReferral.layer.cornerRadius = 27
        imgProfile.backgroundColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 241.0/255.0, alpha: 1)
        
        if let data = user.image {
            imgProfile.image = UIImage(data: data)
            imgProfile.contentMode = UIViewContentMode.scaleAspectFill
        }else if let data = UserDefaults.standard.value(forKeyPath: "profile_image") as? Data {
            imgProfile.image = UIImage(data: data)
            imgProfile.contentMode = UIViewContentMode.scaleAspectFill
        }
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
        if value == "" {
            return
        }
        self.user.refferedBy = value
        buttonReferral.setTitle(value, for: UIControlState.normal)
    }
}



