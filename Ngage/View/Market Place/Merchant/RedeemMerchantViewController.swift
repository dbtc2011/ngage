//
//  RedeemMerchantViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class RedeemMerchantViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var imgPoweredBy: UIImageView! //remove when correct image is available
    @IBOutlet weak var imgGift: UIImageView! //remove when correct image is available
    
    @IBOutlet weak var txtPointsToConvert: UITextField!
    @IBOutlet weak var lblEquivalentInPeso: UILabel!
    
    @IBOutlet weak var btnLocations: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        self.navigationController?.isNavigationBarHidden = true
        
        addDoneButtonKeyboardAccessory(forTextfield: txtPointsToConvert)
        
        //remove when correct image is available
        imgPoweredBy.layer.cornerRadius = imgPoweredBy.frame.width/2
        imgGift.layer.cornerRadius = imgGift.frame.width/2
        
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
        locationsVC.modalPresentationStyle = .overCurrentContext
        locationsVC.modalTransitionStyle = .crossDissolve
        
        self.present(locationsVC, animated: true, completion: nil)
    }
    
    @IBAction func didPressContinue(_ sender: UIButton) {
    }
}
