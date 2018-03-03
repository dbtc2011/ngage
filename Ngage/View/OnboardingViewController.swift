//
//  OnboardingViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 31/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class OnboardingViewController: UIViewController {

    var user : UserModel!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageFirst: UIImageView!
    @IBOutlet weak var imageSecond: UIImageView!
    @IBOutlet weak var imageThird: UIImageView!
    var loginButton : LoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        // Add a custom login button to your app
        loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.delegate = self
        loginButton.frame.size.width = 220
        loginButton.frame.size.height = 50
        loginButton.center = view.center
        loginButton.frame.origin.y = UIScreen.main.bounds.size.height - 90
        loginButton.isHidden = true
        view.addSubview(loginButton)
        
        pageIndicator.currentPage = 0
        pageIndicator.isEnabled = false
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, age_range, gender, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.user = UserModel()
                    let dict = result as! [String : Any]
                    if let ageDict = dict["age_range"] as? NSDictionary {
                        self.user.age = "\(ageDict["min"] as? Int ?? 0)"
                    }
                    self.user.emailAddress = dict["email"] as? String ?? ""
                    self.user.gender = dict["gender"] as? String ?? ""
                    self.user.facebookId = dict["id"] as? String ?? ""
                    self.user.name = dict["name"] as? String ?? ""
                    self.user.emailAddress = dict["email"] as? String ?? ""
        
                    if let pictureDict = dict["picture"] as? NSDictionary {
                        if let pictureDataDict = pictureDict["data"] as? NSDictionary {
                            let imageUrl = URL(string: pictureDataDict["url"] as! String)
                            self.getDataFromUrl(url: imageUrl!, completion: { (data, response, error) in
                                guard let data = data, error == nil else {
                                    print("No Image to download")
                                    return
                                    
                                }
                                print("Download Finished")
                                self.user.image = data
                                UserDefaults.standard.setValue(data, forKey: "profile_image")
                                DispatchQueue.main.async {
                                    self.goToLogin()
                                }
                            })
                        }
                    }
                    print(result!)
                }
            })
        }
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func goToLogin() {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let controller = segue.destination as? LoginViewController {
            controller.user = self.user
        }
    }
 

}

extension OnboardingViewController : LoginButtonDelegate {
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

extension OnboardingViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x/self.view.frame.size.width
        print(index)
        pageIndicator.currentPage = Int(index)
        switch Int(index) {
        case 2:
            self.loginButton.isHidden = false
        default:
            self.loginButton.isHidden = true
        }
    }
}
