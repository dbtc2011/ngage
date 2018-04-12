//
//  MSISDNViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 31/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class MSISDNViewController: MainViewController {

    var user : UserModel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonCarrier: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSubmit.layer.cornerRadius = 27 
        buttonCarrier.layer.cornerRadius = 15
        buttonCarrier.layer.borderWidth = 0.5
        buttonCarrier.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Methods
    func registerUser() {
        showSpinner()
        UserDefaults.standard.set(false, forKey: Keys.keyHasStartedMission)
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
        user.mobileNumber = textField.text ?? ""
        user.referralCode = String(user.facebookId.characters.prefix(4) + user.mobileNumber.characters.suffix(4))
        UserDefaults.standard.set(user.referralCode, forKey: Keys.ReferralCode)
        RegisterService.register(fbid: user.facebookId, fName: firstName, lName: lastName, gender: user.gender, email: user.emailAddress, referralCode: user.referralCode, msisdn: user.mobileNumber, operatorID: user.operatorID, refferedBy: user.refferedBy) { (result, error) in
            self.hideSpinner()
            if error != nil {
                self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
            }else {
                if let userRegistration = result!["user_registration"].dictionary {
                    if let statusCode = userRegistration["StatusCode"]?.int {
                        if statusCode == 2 || statusCode == 8
                        {
                            self.user.points = "\(userRegistration["Points"]?.int ?? 0)"
                            if let missionsStarted = userRegistration["MissionStarted"]?.array {
                                if missionsStarted.count == 0 {
                                    TimeManager.sharedInstance.shouldEditMission = true
                                }else {
                                    if let missionCode = missionsStarted[0].int {
                                        UserDefaults.standard.set(true, forKey: Keys.keyHasStartedMission)
                                        UserDefaults.standard.set(missionCode, forKey: Keys.keyMissionCode)
                                        TimeManager.sharedInstance.resetTimeStamp()
                                    }
                                }
                            }
                            if CoreDataManager.sharedInstance.getMainUser() == nil {
                                CoreDataManager.sharedInstance.saveModelToCoreData(withModel: self.user as AnyObject, completionHandler: { (result) in
                                    // Success
//                                    self.goToMain()
                                    self.goToTutorial()
                                })
                            } else {
                                CoreDataManager.sharedInstance.updateUserPoints(withPoints: self.user.points, completionHandler: { (result) in
                                    self.goToTutorial()
                                })
                                
                            }
                            
                        }else if statusCode == 9{
                            TimeManager.sharedInstance.shouldEditMission = true
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToPinVerification", sender: self)
                            }
                        }else {
                            self.presentDefaultAlertWithMessage(message: "Registration failed!")
                        }
                    }else {
                        // Show error
                        self.presentDefaultAlertWithMessage(message: "Registration failed!")
                    }
                }else {
                    self.presentDefaultAlertWithMessage(message: "Registration failed!")
                    // Show error
                }
                
            }
            print("Result = \(String(describing: result))")
            print("error = \(String(describing: error))")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PinVerificationViewController {
            print("Should go to pin verification")
            controller.user = self.user
        } else if let controller = segue.destination as? TutorialViewController {
            
        }
    }
    
    func goToMain() {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: Bundle.main)
            let controller = storyBoard.instantiateInitialViewController()
            self.present(controller!, animated: true, completion: {
                
            })
        }
    }
    func goToTutorial() {
        //goToTutorial
        if let hasFinishedTutorial = UserDefaults.standard.bool(forKey: Keys.hasFinishedTutorial) as? Bool {
            if hasFinishedTutorial {
                goToMain()
                return
            }
        }
        performSegue(withIdentifier: "goToTutorial", sender: self)
    }
    
    //MARK: - Button Action
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        guard textField.text!.count > 0 else { return }
        guard self.user.operatorID != "" else { return }
        
        registerUser()
    }
    
    @IBAction func carrierButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: "Operator ID", rows: ["Globe/TM", "Smart/TNT", "Sun"], initialSelection: 0, doneBlock: { (picker, index, value) in
            switch index {
            case 0 :
                self.user.operatorID = "51502"
            case 1 :
                self.user.operatorID = "51503"
            case 2 :
                self.user.operatorID = "51505"
            default:
                self.user.operatorID = "51502"
            }
            self.buttonCarrier.setTitle((value as! String), for: UIControlState.normal)
            return
        }, cancel: { (picker) in
            return
        }, origin: sender)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = textField.text! + string
        if newText.count <= 11 {
            return true
        }
        return false
    }
    
}
