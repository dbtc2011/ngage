//
//  TaskInstructionsViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 17/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class TaskInstructionsViewController: UIViewController {
    
    var task : TaskModel!
    var mission : MissionModel!
    var questions : [QuestionsModel] = []
    var user = UserModel().mainUser()
    
    @IBOutlet weak var imageQuiz: UIImageView!
    
    @IBOutlet weak var labalQuiz: UILabel!
    
    @IBOutlet weak var buttonStart: UIButton!
    
    @IBOutlet weak var firstInstruction: UILabel!
    
    @IBOutlet weak var seconInstruction: UILabel!
    
    @IBOutlet weak var thirdInstruction: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    func setupUI() {
        if task.type == 17 || task.type == 7 {
            imageQuiz.image = UIImage(named: "bg_rules_quiz")
            let countValue = "\(questions.count * 6)"
            seconInstruction.text! = seconInstruction.text!.replacingOccurrences(of: "{sec}", with: countValue)
        }else if task.type == 8 {
            imageQuiz.image = UIImage(named: "bg_rules_tone")
            seconInstruction.text = "You gave 10 seconds to answer each question."
        }
        view.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        labalQuiz.text = task.info
        thirdInstruction.text = task.instructions
        buttonStart.layer.cornerRadius = 27
        buttonStart.layer.borderWidth = 2
        buttonStart.layer.borderColor = UIColor.white.cgColor
    }
    func getData() {
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            if let result = result {
                if let contents = result["content"].array {
                    for content in contents {
                        let questionaire = QuestionsModel(info: content)
                        self.questions.append(questionaire)
                    }
                    
                    DispatchQueue.main.async {
                        self.setupUI()
                    }
                    
                }else {
                    let alertController = UIAlertController(title: "Ngage PH", message: "Locked Mission Per Day", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }else {
                let alertController = UIAlertController(title: "Ngage PH", message: error!.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func openQuestionaireWithMusic(task: TaskModel) {
        
        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "MultipleChoiceTaskViewController") as? MultipleChoiceTaskViewController {
            controller.task = task
            controller.mission = mission
            controller.questions = questions
            controller.maxTime = questions.count * 6
            self.navigationController?.pushViewController(controller, animated: true)
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
    @IBAction func startButtonClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.openQuestionaireWithMusic(task: self.task)
        }
    }
    
}
