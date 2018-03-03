//
//  RedeemMerchantViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

struct RedeemMerchantForm {
    var fullName = ""
    var mobileNumber = ""
    var emailAddress = ""
    var message = ""
    var points = ""
}

class RedeemMerchantViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var txtPointsToConvert: UITextField!
    @IBOutlet weak var lblEquivalentInPeso: UILabel!
    
    @IBOutlet weak var btnLocations: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet var bgOuter1: UIView!
    @IBOutlet var bgOuter2: UIView!
    
    var redeemable: MerchantRedeemableModel!
    var formDetails = RedeemMerchantForm()
    
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
        
        addDoneButtonKeyboardAccessory(forTextfield: txtPointsToConvert)
        
        bgOuter1.layer.cornerRadius = bgOuter1.frame.width/2
        bgOuter2.layer.cornerRadius = bgOuter2.frame.width/2
        
        btnLocations.layer.cornerRadius = 5.0
        btnContinue.layer.cornerRadius = 5.0
    }
    
    private func addDoneButtonKeyboardAccessory(forTextfield textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        textField.inputAccessoryView = keyboardToolbar
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didPressBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressLocations(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RedeemStoryboard", bundle: Bundle.main)
        let locationsVC = storyboard.instantiateViewController(withIdentifier: "merchantLocations") as! MerchantLocationsViewController
        locationsVC.merchantId = "\(redeemable.id)"
        locationsVC.modalPresentationStyle = .overCurrentContext
        locationsVC.modalTransitionStyle = .crossDissolve
        
        self.present(locationsVC, animated: true, completion: nil)
    }
    
    @IBAction func didPressContinue(_ sender: UIButton) {
        guard formDetails.points != "" else {
            let ac = UIAlertController(title: "Ngage", message: "Input points to convert", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            
            return
        }
        
        let storyboard = UIStoryboard(name: "RedeemStoryboard", bundle: Bundle.main)
        let formVC = storyboard.instantiateViewController(withIdentifier: "redeemMerchantForm") as! RedeemMerchantFormViewController
        formVC.formDetails = formDetails
        formVC.redeemable = redeemable
        
        self.navigationController?.pushViewController(formVC, animated: true)
    }
}

//MARK: - Textfield Delegate

extension RedeemMerchantViewController:  UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        formDetails.points = textField.text!
    }
}
