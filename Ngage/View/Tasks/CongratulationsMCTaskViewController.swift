//
//  CongratulationsMCTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 17/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class CongratulationsMCTaskViewController: UIViewController {
    var mission : MissionModel!
    var task : TaskModel!

    @IBOutlet weak var imgTimer: UIImageView!
    
    @IBOutlet weak var labelWrong: UILabel!
    @IBOutlet weak var labelCorrect: UILabel!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelTotal: UILabel!
    var correctAnswer = 0
    var wrongAnswer = 0
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
        view.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        if task.type != 17 {
            imgTimer.image = #imageLiteral(resourceName: "img_wave")
        }
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        labelCorrect.text = "\(correctAnswer)"
        labelWrong.text = "\(wrongAnswer)"
        labelTotal.text = "\(correctAnswer) of \(correctAnswer + wrongAnswer)"
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        if let controller = navigationController?.viewControllers[1] as? TaskViewController {
            _ = navigationController?.popToViewController(controller, animated: true)
            controller.didFinishTask(task: task)
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
