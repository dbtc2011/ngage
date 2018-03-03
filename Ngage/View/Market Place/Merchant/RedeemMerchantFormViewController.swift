//
//  RedeemMerchantFormViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class RedeemMerchantFormViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var lblTotalPoints: UILabel!
    @IBOutlet weak var lblConvertedPoints: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tblForm: UITableView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var redeemable: MerchantRedeemableModel!
    var formDetails: RedeemMerchantForm!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        self.navigationController?.isNavigationBarHidden = true
        
        viewContainer.layer.cornerRadius = 5.0
        btnBack.layer.cornerRadius = 5.0
        btnNext.layer.cornerRadius = 5.0
        
        var userPoints = 0
        if let points = Int(UserModel().mainUser().points) {
            userPoints = points
        }
        
        lblConvertedPoints.text = formDetails.points + " pts."
        lblTotalPoints.text = "\(userPoints) pts."
        
        tblForm.reloadData()
    }
    
    private func addDoneButtonKeyboardAccessory(forTextfield textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        textField.inputAccessoryView = keyboardToolbar
    }
    
    private func displayAlert(withMessage message: String) {
        DispatchQueue.main.async {
            self.btnNext.isEnabled = true
            
            let alert = UIAlertController(title: "Ngage", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - API
    
    private func redeemFromMerchant() {
        RegisterService.orderProcess(merchant: redeemable, redeemDetails: formDetails) { (json, error) in
            guard error == nil else {
                self.displayAlert(withMessage: error!.localizedDescription)
                return
            }
            
            guard json != nil else {
                self.displayAlert(withMessage: "An error has occured")
                return
            }
            
            let resultDict = json!.dictionary
            guard resultDict != nil else {
                self.displayAlert(withMessage: "An error has occured")
                return
            }
            
            if let points = resultDict!["Points"], let casted = points.string {
                CoreDataManager.sharedInstance.updateUserPoints(withPoints: casted, completionHandler: { (result) in
                    if result == .Error {
                        print(CoreDataManager.sharedInstance.errorDescription)
                    }
                })
            }
            
            if let statusCode = resultDict!["statusCode"], let castedStatusCode = statusCode.int {
                var alertMessage = "Successfully redeemed item"
                if castedStatusCode != 200 {
                    if let status = resultDict!["status"], let castedStatus = status.string {
                        alertMessage = castedStatus
                    }
                }
                
                self.displayAlert(withMessage: alertMessage)
            }
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didPressBack(_ sender: UIButton) {
        sender.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressNext(_ sender: UIButton) {
        sender.isEnabled = false
        
        guard formDetails.fullName != "" && formDetails.emailAddress != "" && formDetails.mobileNumber != "" else {
            displayAlert(withMessage: "Incomplete input")
                    
            return
        }
        
        redeemFromMerchant()
    }
}

//MARK: - UITableView

//MARK: Data Source

extension RedeemMerchantFormViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let messageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MerchantFormMessageTableViewCell
            messageCell.txtMessage.delegate = self
            
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit()
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.view, action: #selector(UIView.endEditing(_:)))
            keyboardToolbar.items = [flexBarButton, doneBarButton]
            
            messageCell.txtMessage.inputAccessoryView = keyboardToolbar
            
            return messageCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! MerchantFormInfoTableViewCell
        infoCell.txtInfo.delegate = self
        infoCell.txtInfo.tag = indexPath.row
        infoCell.txtInfo.keyboardType = .default
        
        switch indexPath.row {
        case 0:
            infoCell.lblInfo.text = "Full Name:"
            
        case 1:
            infoCell.lblInfo.text = "Mobile:"
            infoCell.txtInfo.keyboardType = .numberPad
            
        default:
            infoCell.lblInfo.text = "Email Address:"
        }
        
        addDoneButtonKeyboardAccessory(forTextfield: infoCell.txtInfo)
        
        return infoCell
    }
}

extension RedeemMerchantFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 3 {
            return 80
        }
        
        return 190
    }
}

//MARK: - UITextfield Delegate

extension RedeemMerchantFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            formDetails.fullName = textField.text!
            
        case 1:
            formDetails.mobileNumber = textField.text!
            
        default:
            formDetails.emailAddress = textField.text!
        }
    }
}

//MARK: - UITextView Delegate

extension RedeemMerchantFormViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        formDetails.message = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tblForm.scrollToRow(at: IndexPath(row: 3, section: 0), at: .bottom, animated: true)
    }
}
