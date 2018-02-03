//
//  MSISDNViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 31/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MSISDNViewController: UIViewController {

    var user : UserModel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonCarrier: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser() {
        
        let name = user.name.components(separatedBy: " ")
        var firstName = ""
        var lastName = ""
        for content in name {
            
            if content == name.last{
                lastName = content
            }else if content == name.first {
                firstName = content
            }else {
                firstName = firstName + " \(content)"
            }
        }
        
        user.mobileNumber = "09777870229"
        let referral = String(user.facebookId.characters.prefix(4) + user.mobileNumber.characters.suffix(4))
        print("refferal = \(referral)")
        
        RegisterService.register(fbid: user.facebookId, fName: firstName, lName: lastName, gender: user.gender, email: user.emailAddress, referralCode: "0000000", msisdn: "09777870229", operatorID: "51502", refferedBy: "") { (result, error) in
            
            print("Result = \(String(describing: result))")
            print("error = \(String(describing: error))")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToPinVerification", sender: self)
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
    
    //MARK: - Button Action
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        registerUser()
    }
    
    @IBAction func carrierButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
extension MSISDNViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
