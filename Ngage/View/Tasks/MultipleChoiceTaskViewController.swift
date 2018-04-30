//
//  MultipleChoiceTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 06/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
class MultipleChoiceTaskViewController: UIViewController {
    
    let user = UserModel().mainUser()
    var mission: MissionModel!
    var task:  TaskModel!
    var currentQuestion = 0
    var player : AVPlayer?
    
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var viewQuestioniare: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    var questions : [QuestionsModel] = []
    var correctTag = 1
    var timeLimit : Timer?
    var maxTime = 40
    var currentTime : Int!
    var currentPath = ""
    var playerView : TaskNameThatSountPlayerView?
    var correctAnswer = 0
    var wrongAnswer = 0
    var correctAnswers = ""
    var answers = ""
    var questionNumber = 1
    var isAudio = false
    
    var divider : CGFloat {
        return 100.0/CGFloat(maxTime)
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.barTintColor = viewContainer.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Functions
    func setupUI() {
        var backgroundColor = ""
        switch task.type {
        case 8:
            backgroundColor = "#4f2370"
        default:
            backgroundColor = "#de4347"
        }
        viewHeader.backgroundColor = UIColor().setColorUsingHex(hex: backgroundColor)
        viewQuestioniare.backgroundColor = UIColor().setColorUsingHex(hex: backgroundColor)
        view.backgroundColor = UIColor().setColorUsingHex(hex: backgroundColor)
        viewContainer.backgroundColor = UIColor().setColorUsingHex(hex: backgroundColor)
        button1.layer.cornerRadius = 10
        button2.layer.cornerRadius = 10
        button3.layer.cornerRadius = 10
        button4.layer.cornerRadius = 10
        currentTime = maxTime
        self.labelTimer.text = "\(self.maxTime)"
        button1.setAsDefault()
        button2.setAsDefault()
        button3.setAsDefault()
        button4.setAsDefault()
        setupNameThatSound()
        setupQuestionaire()
        
        switch task.type {
        case 17, 7:
            scheduleTimer()
        default:
            maxTime = 10
            currentTime = 10
            self.labelTimer.text = "\(self.maxTime)"
            break
        }
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
                        self.setupQuestionaire()
                    }
                }
                
            }
        }
    }
    
    func playSong() {
        print(currentPath)
        var fileURL = currentPath.replacingOccurrences(of: "http", with: "https")
        fileURL = fileURL.replacingOccurrences(of: "httpss", with: "https")
        fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: fileURL) {
            player = AVPlayer(url: url)
            player!.play()
            playerView!.buttonWidth.constant = 0
        }else {
            print("URL not playable ----> \(fileURL)")
        }
        
    }
    func setupQuestionaire() {
        if questionNumber != 1 {
            correctAnswers = correctAnswers + ","
        }
        
        let question = questions[currentQuestion]
        currentPath = question.filePath
        correctTag = question.getCorrectAnswer() + 1
        correctAnswers = correctAnswers + question.answer
        if question.isLogo {
            let imageUrl = URL(string: currentPath)
            self.getDataFromUrl(url: imageUrl!, completion: { (data, response, error) in
                guard let data = data, error == nil else {
                    print("No Image to download")
                    return
                    
                }
                print("Download Finished")
                
                DispatchQueue.main.async {
                    self.playerView!.imageLogo.image = UIImage(data: data)
                }
            })
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            if self.task.type == 8 {
                self.labelTimer.text = "\(self.maxTime)"
            }
            self.button1.setAsDefault()
            self.button2.setAsDefault()
            self.button3.setAsDefault()
            self.button4.setAsDefault()
        }) { (value) in
            if self.playerView != nil {
                self.playerView!.title.text = question.question
            }
            self.button1.setTitle(question.choices[0], for: UIControlState.normal)
            self.button2.setTitle(question.choices[1], for: UIControlState.normal)
            self.button3.setTitle(question.choices[2], for: UIControlState.normal)
            self.button4.setTitle(question.choices[3], for: UIControlState.normal)
        }
    }
    func scheduleTimer() {
        
        timeLimit = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.currentTime == 0 {
                self.labelTimer.text = "\(self.currentTime!)"
                timer.invalidate()
                if self.task.type == 17 {
                    self.submitTask()
                }else {
                    self.player = nil
                    self.playerView?.buttonWidth.constant = 42
                    self.answerdQuestion()
                }
                return
            }
            DispatchQueue.main.async {
                self.labelTimer.text = "\(self.currentTime!)"
                print("Time = \(self.currentTime!)")
            }
            self.currentTime = self.currentTime - 1
            
        })
    }
    func submitTask() {
        finishedTask()
    }
    
    func answerdQuestion() {
        if currentQuestion == questions.count - 1 {
            submitTask()
            return
        }
        currentQuestion = currentQuestion + 1
        setupQuestionaire()
    }
    
    func finishedTask() {
        if timeLimit != nil {
            timeLimit!.invalidate()
        }
        self.player = nil
        performSegue(withIdentifier: "congratulations", sender: self)
//        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setupNameThatSound() {
        let question = questions[currentQuestion]
        playerView = (Bundle.main.loadNibNamed("TaskNameThatSoundView", owner: self, options: nil)?.first as! TaskNameThatSountPlayerView)
        playerView!.bounds = viewContainer.bounds
        playerView?.backgroundColor = UIColor.clear
        playerView!.delegate = self
        playerView!.frame.origin = CGPoint(x: 0, y: 0)
        if task.type == 17 {
            playerView!.buttonWidth.constant = 0
            if question.isLogo {
                playerView!.labelBottomConstraint.constant = viewContainer.frame.size.height - 55
                playerView!.imageLogo.isHidden = false
                playerView!.imageLogo.backgroundColor = UIColor.clear
            }
        }else if task.type == 8 {
            playerView!.buttonWidth.constant = 42
        }
        viewContainer.addSubview(playerView!)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? CongratulationsMCTaskViewController {
            controller.task = task
            controller.mission = mission
            controller.correctAnswer = correctAnswer
            controller.wrongAnswer = wrongAnswer
            controller.correctAnswers = correctAnswers
            controller.answers = answers
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        finishedTask()
    }
    @IBAction func answerButtonClicked(_ sender: UIButton) {
        if task.type == 8 {
            if player == nil {
                view.isUserInteractionEnabled = false
                UIView.animate(withDuration: 1, animations: {
                    self.playerView?.button.highlight()
                }, completion: { (value) in
                    self.view.isUserInteractionEnabled = true
                })
                return
            }
            
            if timeLimit != nil {
                timeLimit!.invalidate()
            }
            playerView?.buttonWidth.constant = 42
            player = nil
        }
        
        if questionNumber != 1 {
            answers = answers + ","
        }
        answers = answers + (sender.titleLabel?.text ?? "")
        if sender.tag == correctTag {
            correctAnswer = correctAnswer + 1
        }else {
            wrongAnswer = wrongAnswer + 1
        }
        sender.animateUsing(tag: correctTag)
        if sender.tag != correctTag {
            if let buttonCorrect = viewQuestioniare.viewWithTag(correctTag) as? UIButton {
                buttonCorrect.animateUsing(tag: correctTag)
            }
        }
        questionNumber = questionNumber + 1
        answerdQuestion()
    }
    
}

extension MultipleChoiceTaskViewController : TaskNameThatSountPlayerViewDelegate {
    func didTapPlay() {
        playSong()
        maxTime = 10
        currentTime = 10
        scheduleTimer()
    }
    
    
}
