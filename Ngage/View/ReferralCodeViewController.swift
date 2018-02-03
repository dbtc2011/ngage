//
//  ReferralCodeViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 31/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol ReferralCodeViewControllerDelegate {
    
    func didEnterReferredBy(value: String)
    
}
class ReferralCodeViewController: UIViewController {
    
    var user : UserModel!
    var delegate : ReferralCodeViewControllerDelegate?

    @IBOutlet weak var textField: UITextField!
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
 
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enterButtonClicked(_ sender: UIButton) {
    
        delegate?.didEnterReferredBy(value: textField.text ?? "")
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
}

extension ReferralCodeViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
