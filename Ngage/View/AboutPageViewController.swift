//
//  AboutPageViewController.swift
//  Ngage PH
//
//  Created by Mark Angeles on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var version: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {

        if let versionValue = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            version.text = "Version \(versionValue)"
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? DrawerWebViewController {
            controller.webLink = "https://ngage.ph/tos_ngage.html"
        }
    }
 
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func termsButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTerms", sender: self)
        
        
    }
    
}
