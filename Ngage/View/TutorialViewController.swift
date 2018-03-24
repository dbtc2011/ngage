//
//  TutorialViewController.swift
//  Ngage PH
//
//  Created by Mark Angeles on 24/03/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var labelContent: UILabel!
    var counter = 0
    let message = ["Everyday, a mission will be unlocked for you to play. Accomplish each task in the mission to earn points.", "Use your points to redeem exciting items. Redeem loads and eGifts from our list of selected merchants."]
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    //MARK: - Method
    func setupUI() {
        buttonNext.layer.cornerRadius = 27
        labelContent.text = message[counter]
    }
    
    func goToMain() {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: Bundle.main)
            let controller = storyBoard.instantiateInitialViewController()
            self.present(controller!, animated: true, completion: {
                
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
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        counter = counter + 1
        
        if counter == 2 {
            goToMain()
            return
        }
        labelContent.text = message[counter]
        
    }
    
}
