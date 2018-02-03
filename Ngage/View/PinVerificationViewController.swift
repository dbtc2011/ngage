//
//  PinVerificationViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 01/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class PinVerificationViewController: UIViewController {
    
    
    @IBOutlet weak var labelPleaseWait: UILabel!
    
    @IBOutlet weak var buttonVerify: UIButton!
    @IBOutlet weak var buttonResend: UIButton!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func resendButtonClicked(_ sender: UIButton) {
    }
    @IBAction func verifyButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
