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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a custom login button to your app
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, age_range, gender, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(result!)
                }
            })
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

}

extension LoginViewController : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
    
    }
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print("error = \(error)")
        case .cancelled:
            print("Cancelled")
        case .success(grantedPermissions: let granterPermision, declinedPermissions: let declinedPermision, token: let accessToken):
            print("Permisions \(granterPermision) \(declinedPermision)")
            print("User = \(accessToken.userId!)")
            self.getFBUserData()
            break
        }
    
    }
    
}
