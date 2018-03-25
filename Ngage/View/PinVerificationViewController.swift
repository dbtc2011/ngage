//
//  PinVerificationViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 01/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import SwiftyJSON
class PinVerificationViewController: UIViewController {
    
    var user: UserModel!
    var pinCode = ""
    @IBOutlet weak var labelPleaseWait: UILabel!
    
    @IBOutlet weak var buttonVerify: UIButton!
    @IBOutlet weak var buttonResend: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupUI() {
        buttonResend.layer.cornerRadius = 10
        buttonVerify.layer.cornerRadius = 10
        
        labelPleaseWait.text = labelPleaseWait.text?.replacingOccurrences(of: "{number}", with: user.mobileNumber)
    }
    
    func requestPin() {
        self.buttonResend.isEnabled = false
        self.buttonVerify.isEnabled = false
        RegisterService.resendVerificationCode(fbid: self.user.facebookId) { (result, error) in
            self.buttonVerify.isEnabled = true
            self.buttonResend.isEnabled = true
            print(result ?? "Result = nil")
            print(error ?? "error = nil")
           
        }
    }
    
    func validatePin() {
        RegisterService.validateRegistration(fbid: user.facebookId, pCode: textField.text!, mobileNumber: user.mobileNumber) { (result, error) in
            
            if error != nil {
                // Show error alert
            }else {
                if let _ = result?["user_registration"].dictionary {
                    CoreDataManager.sharedInstance.saveModelToCoreData(withModel: self.user as AnyObject, completionHandler: { (result) in
                        DispatchQueue.main.async {
                            let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: Bundle.main)
                            let controller = storyBoard.instantiateInitialViewController()
                            self.present(controller!, animated: true, completion: {
                                
                            })
                        }
                    })
                }
            }
            print("Result = \(result)")
            print("Error = \(error)")
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
    
    //MARK: - Button Actions

    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func resendButtonClicked(_ sender: UIButton) {
        requestPin()
    }
    @IBAction func verifyButtonClicked(_ sender: UIButton) {
        if textField.text?.characters.count == 4 {
            validatePin()
        }else {
            //error handling
            print("Input pin")
        }
        
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
