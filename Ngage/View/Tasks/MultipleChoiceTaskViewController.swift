//
//  MultipleChoiceTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 06/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import UICircularProgressRing
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
    @IBOutlet weak var progressView: UICircularProgressRingView!
    var timeLimit : Timer?
    var maxTime = 40
    var currentTime : Int!
    var currentPath = ""
    var playerView : TaskNameThatSountPlayerView?
    
    var divider : CGFloat {
        return 100.0/CGFloat(maxTime)
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        getData()
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
        viewHeader.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        viewQuestioniare.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        view.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        viewContainer.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
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
        switch task.type {
        case 17:
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
        
        let question = questions[currentQuestion]
        currentPath = question.filePath
        correctTag = question.getCorrectAnswer() + 1
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            if self.task.type != 17 {
                self.playerView!.buttonWidth.constant = 42
                self.progressView.setProgress(value: 100.0, animationDuration: 1)
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
                    self.progressView.setProgress(value: 100.0, animationDuration: 1)
                    self.labelTimer.text = "\(self.maxTime)"
                    self.player = nil
                    self.answerdQuestion()
                }
                return
            }
            DispatchQueue.main.async {
//                self.progressView.valueIndicator = ""
                self.currentTime = self.currentTime - 1
                self.progressView.setProgress(value: self.progressView.currentValue! - self.divider, animationDuration: 1)
                self.labelTimer.text = "\(self.currentTime!)"
            }
            
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
        self.player = nil
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setupNameThatSound() {
        playerView = (Bundle.main.loadNibNamed("TaskNameThatSoundView", owner: self, options: nil)?.first as! TaskNameThatSountPlayerView)
        playerView!.bounds = viewContainer.bounds
        playerView?.backgroundColor = UIColor.clear
        playerView!.delegate = self
        playerView!.frame.origin = CGPoint(x: 0, y: 0)
        if task.type == 17 {
            playerView!.buttonWidth.constant = 0
        }
        viewContainer.addSubview(playerView!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        finishedTask()
    }
    @IBAction func answerButtonClicked(_ sender: UIButton) {
        button1.animateUsing(tag: correctTag)
        button2.animateUsing(tag: correctTag)
        button3.animateUsing(tag: correctTag)
        button4.animateUsing(tag: correctTag)
        if task.type != 17 {
            if timeLimit != nil {
                timeLimit!.invalidate()
            }
            player = nil
        }
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
