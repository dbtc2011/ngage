//
//  TaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

import Social
import UICircularProgressRing
import ScratchCard

enum TaskAppCode : Int {
    case updateProfile = 1
}
protocol TaskViewControllerDelegate {
    func taskUpdated(tasks: [TaskModel])
    func mustReloadData()
    func mustShowMarketPlaceAds()
}
class TaskViewController: MainViewController {

    //MARK: - Properties
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var mission: MissionModel!
    var tasks : [TaskModel] = []
    var user = UserModel().mainUser()
    var selectedTask : TaskModel!
    var selectedIndex = 0
    var completedTask = 0
    var taskPoint = ""
    var delegate : TaskViewControllerDelegate?
    var quizAnswers: String!
    var quizCorrectAnswers: String!
    var customProgress: CustomProgressView?
    var customScratch: ScratchUIView?
    var didShowSuccessRedeem = false
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var backgroundLayer: UIImageView!
    var contentID : String = ""
    var contentDuration : String = ""
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelCompleted: UILabel!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        completedTask = 0
        var shouldSetEnabled = false
        var arrayCounter = 0
        var tempTasks : [TaskModel] = []
        for taskReversed in mission.tasks {
            var taskToAdd = taskReversed
            if shouldSetEnabled && taskReversed.state == 0{
                taskToAdd.state = 1
                shouldSetEnabled = false
            }else if shouldSetEnabled && taskReversed.state == 1 {
                shouldSetEnabled = false
            }
            if taskReversed.state == 2 {
                completedTask = completedTask + 1
                shouldSetEnabled = true
            }else if taskReversed.state == 0 && arrayCounter == 0 {
                taskToAdd.state = 1
            }
            
            arrayCounter = arrayCounter + 1
            tempTasks.append(taskToAdd)
        }
        tasks = tempTasks.reversed()
        tableView.reloadData()
        setupUI()
        if completedTask == mission.tasks.count {
            setupCompleted()
        }else {
            setupProgressView()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let color = UIColor().setColorUsingHex(hex: mission.colorBackground)
        navigationController?.navigationBar.barTintColor = color
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        adjustProgressBar()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    func adjustProgressBar() {
        
        var currentProgress = 100.0/CGFloat(tasks.count)
        currentProgress = currentProgress * CGFloat(completedTask)
        print("Progress=\(currentProgress)")
        customProgress?.setupContent(currentProgress: Double(currentProgress))
    }
    func setupUI() {
        customView.isHidden = true
        customView.backgroundColor = UIColor.clear
        labelTitle.text = mission.title
//        self.progress.setProgress(value: 0, animationDuration: 1)
        if mission.imageTask!.data != nil {
            if let imageData = UIImage(data: mission.imageTask!.data!) {
                backgroundImage.image = imageData
                backgroundLayer.image = imageData
                
            }
        }else {
            backgroundImage.image = UIImage(named: "img_splash")
            backgroundLayer.image = UIImage(named: "img_splash")
        }
        backgroundLayer.addBlurEffect()
    }
    
    func setupProgressView() {
        customProgress = Bundle.main.loadNibNamed("CustomProgressView", owner: self, options: nil)?.first as? CustomProgressView
        customProgress!.bounds = progressView.bounds
        customProgress!.frame.origin = CGPoint(x: 0, y: 0)
        customProgress!.setupProgressColor(color: UIColor().setColorUsingHex(hex: mission.colorBackground))
        progressView.addSubview(customProgress!)
        adjustProgressBar()
    }
    
    func setupCompleted() {
        //ic_reward_redeem
        for view in progressView.subviews {
            view.removeFromSuperview()
        }
        customProgress = nil
        labelCompleted.isHidden = true
        let imageScratch = UIImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        imageScratch.contentMode = .scaleAspectFit
        imageScratch.image = UIImage(named: "img_reward_points")
        progressView.addSubview(imageScratch)
        
        let imageRedeem = UIImageView(frame: CGRect(x: (140/2)-(117/2), y: (140/2)-(76/2), width: 117, height: 76))
        imageRedeem.contentMode = .scaleAspectFit
        imageRedeem.image = UIImage(named: "ic_reward_redeem")
        progressView.addSubview(imageRedeem)
        
    }
    func setupScratchView() {
        if customProgress != nil {
            customProgress!.removeFromSuperview()
            customProgress = nil
        }
        var scratchPoint = mission.reward
        if scratchPoint == "0" || scratchPoint == "1" {
            scratchPoint = scratchPoint + "pt"
        }else {
            scratchPoint = scratchPoint + "pts"
        }
        UserDefaults.standard.setValue(scratchPoint, forKey: Keys.sratchPoint)
        customScratch  = ScratchUIView(frame: CGRect(x:0, y:0, width:140, height:140),Coupon: "img_reward_points", MaskImage: "img_scratch_gift", ScratchWidth: CGFloat(40))
        customScratch!.delegate = self
        progressView.addSubview(customScratch!)
    }
    func showSuccessModal(totalPoints: String) {
        customView.isHidden = false
        let modalView = Bundle.main.loadNibNamed("SuccessTaskModalView", owner: self, options: nil)?.first as! SuccessTaskModalView
        modalView.selectedTask = self.selectedTask
        modalView.delegate = self
        modalView.setupContents(pointsTotal: "\(totalPoints)pts", pointsEarned: Int(self.taskPoint)!)
        modalView.bounds = customView.bounds
        modalView.frame.origin = CGPoint(x: 0, y: 0)
        customView.addSubview(modalView)
    }
    
    func showSuccessRedeemModal() {
        didShowSuccessRedeem = true
        customView.isHidden = false
        let modalView = Bundle.main.loadNibNamed("CustomModalView", owner: self, options: nil)?.first as! CustomModalView
        modalView.delegate = self
        modalView.tag = 13
        modalView.icon.image = UIImage(named: "ic_app_logo_circle")
        modalView.setupContent(value: "Congratulations!\nYou have been rewarded with \(mission.reward) Points for completing \(mission.title)")
        modalView.button.setTitle("Ok", for: UIControlState.normal)
        modalView.bounds = customView.bounds
        modalView.frame.origin = CGPoint(x: 0, y: 0)
        customView.addSubview(modalView)
    }
    
    func adjustTasks() {
        completedTask = completedTask + 1
        adjustProgressBar()
        var finishedTask = selectedTask!
        finishedTask.state = 2
        tasks[selectedIndex] = finishedTask
        if selectedIndex != 0 {
            var nextTask = tasks[selectedIndex-1]
            nextTask.state = 1
            tasks[selectedIndex-1] = nextTask
        }
        tableView.reloadData()
        if mission.code == 1 && selectedIndex == 0 {
            TimeManager.sharedInstance.hasFinishedFirstTask = true
            delegate?.mustReloadData()
            delegate?.mustShowMarketPlaceAds()
            performSegue(withIdentifier: "goToSuccess", sender: self.selectedTask)
        }else if selectedIndex == 0 {
            delegate?.mustShowMarketPlaceAds()
            performSegue(withIdentifier: "goToSuccess", sender: self.selectedTask)
        }
        
    }
    
    func quizDidSet(answers: String, correctAnswers: String) {
        quizAnswers = answers
        quizCorrectAnswers = correctAnswers
    }
    
    func setContent(id: String, duration : String) {
        contentID = id
        contentDuration = duration
        if selectedTask.type == 16 {
            let when = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.facebookShare(task: self.selectedTask)
            }
        }else {
            didFinishTask(task: selectedTask)
        }
    }
    
    func cameraTaskFinished(taskCamera: TaskModel) {
//        if taskCamera.type == 11 {
//            let when = DispatchTime.now() + 0.3
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                self.facebookShare(task: taskCamera)
//            }
//        }else {
//            didFinishTask(task: taskCamera)
//        }
        didFinishTask(task: taskCamera)
    }
    func didFinishTask(task: TaskModel) {
        print("Finished task \(task.info)")
        if mission.code != 1 {
            UserDefaults.standard.set(true, forKey: Keys.keyHasStartedMission)
            UserDefaults.standard.set(mission.code, forKey: Keys.keyMissionCode)
            TimeManager.sharedInstance.hasStartedMission = true
            
            TimeManager.sharedInstance.shouldSaveDate = true
            TimeManager.sharedInstance.setTimer()
            UserDefaults.standard.set(mission.code, forKey: Keys.keyMissionCode)
            //            TimeManager.sharedInstance.startedMissionCode = mission.code
        }
        
        switch task.type {
        case 1, 2:
            let totalPoint = Int(user.points)! + Int(task.reward)!
            submitTask(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", FBID: user.facebookId, ContentID: "0", SubContentID: "0", Answer: "", CorrectAnswer: "", WatchType: "", WatchTime: "", DeviceID: user.deviceID, TaskStatus: "2", Current_Points: "\(totalPoint)", Points: task.reward, Prev_Points: user.points)
            
        case 3:
            let totalPoint = Int(user.points)! + Int(task.reward)!
            submitTask(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", FBID: user.facebookId, ContentID: task.contentId, SubContentID: "1", Answer: "", CorrectAnswer: "", WatchType: "", WatchTime: "", DeviceID: user.deviceID, TaskStatus: "2", Current_Points: "\(totalPoint)", Points: task.reward, Prev_Points: user.points)
        case 5, 6, 10:
            let totalPoint = Int(user.points)! + Int(task.reward)!
            submitTask(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", FBID: user.facebookId, ContentID: "0", SubContentID: "1", Answer: "", CorrectAnswer: "", WatchType: "", WatchTime: "", DeviceID: user.deviceID, TaskStatus: "2", Current_Points: "\(totalPoint)", Points: task.reward, Prev_Points: user.points)
            
        case 3 :
            let totalPoint = Int(user.points)! + Int(task.reward)!
            submitTask(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", FBID: user.facebookId, ContentID: contentID, SubContentID: "0", Answer: "", CorrectAnswer: "", WatchType: "video", WatchTime: contentDuration, DeviceID: user.deviceID, TaskStatus: "2", Current_Points: "\(totalPoint)", Points: task.reward, Prev_Points: user.points)
        case 7, 8, 17:
            let totalPoint = Int(user.points)! + Int(task.reward)!
            print("Answers = \(quizAnswers)")
            print("Correct Answers = \(quizCorrectAnswers)")
            submitTask(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", FBID: user.facebookId, ContentID: "0", SubContentID: "1", Answer: quizAnswers, CorrectAnswer: quizCorrectAnswers, WatchType: "", WatchTime: "", DeviceID: user.deviceID, TaskStatus: "2", Current_Points: "\(totalPoint)", Points: task.reward, Prev_Points: user.points)
            quizCorrectAnswers = ""
            quizAnswers = ""
            
        default:
            let totalPoint = Int(user.points)! + Int(task.reward)!
            submitTask(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", FBID: user.facebookId, ContentID: "0", SubContentID: "1", Answer: "", CorrectAnswer: "", WatchType: "", WatchTime: "", DeviceID: user.deviceID, TaskStatus: "2", Current_Points: "\(totalPoint)", Points: task.reward, Prev_Points: user.points)
        }
        
        //        adjustTasks()
    }
    
    
    //MARK: - Open tasks
    func openTask() {
        switch self.selectedTask.type {
        case 1, 2, 12, 13, 14, 15:
            performSegue(withIdentifier: "webViewTask", sender: self.selectedTask)
        case 3, 16:
            playVideo(task: self.selectedTask)
        case 5:
            facebookShare(task: self.selectedTask)
        case 6:
            openContactList(task: self.selectedTask)
        case 7, 8, 17:
            openQuestionaireWithMusic(task: self.selectedTask)
        case 9:
            installTask(task: self.selectedTask)
            
        case 10, 11:
            showPhotoPopOver()
            
        default:
            break
        }
    }
    
    func facebookShare(task: TaskModel) {
        //FBShareTaskViewController
        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "FBShareTaskViewController") as? FBShareTaskViewController {
            controller.task = task
            controller.mission = mission
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func playVideo(task: TaskModel) {
        
        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "VideoTaskViewController") as? VideoTaskViewController {
            controller.task = task
            controller.mission = mission
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func openQuestionaireWithMusic(task: TaskModel) {
        selectedTask = task
        performSegue(withIdentifier: "taskInstructions", sender: task)
        
    }

    func openContactList(task: TaskModel) {
        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "ContactListViewController") as? ContactListViewController {
            controller.task = task
            controller.mission = mission
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func installTask(task: TaskModel) {
//        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
//        if let controller = storyBoard.instantiateViewController(withIdentifier: "InstallTaskViewController") as? InstallTaskViewController {
//            controller.task = task
//            controller.mission = mission
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
    }
    
    func scratchMoved(_ view: ScratchUIView) {
        if self.customScratch!.getScratchPercent() > 0.5 && !self.didShowSuccessRedeem {
            self.showSuccessRedeemModal()
        }
    }
    
    //MARK: - API
    
    func getRewardPoints() {
        showSpinner()
        let previous = user.points
        let pointeg = "\(Int(user.points)! + Int(mission.reward)!)"
        
        RegisterService.redeemPoints(FBID: user.facebookId, MissionID: "\(mission.code)", TaskID: "\(self.selectedTask.code)", Prev_Pointegers: previous, Current_Pointegers: pointeg, Pointegers: mission.reward) { (result, error) in
            self.hideSpinner()
            if error != nil {
                self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
            }else {
                self.setupScratchView()
            }
            
        }
    }
    func submitTask(missionID: String, taskID: String, tasktype: String, FBID: String, ContentID: String, SubContentID: String, Answer: String, CorrectAnswer: String, WatchType: String, WatchTime: String, DeviceID: String, TaskStatus: String, Current_Points: String, Points: String, Prev_Points: String) {
        self.showSpinner()
        self.user.points = UserModel().mainUser().points
        RegisterService.insertRecord(missionID: missionID, taskID: taskID, tasktype: tasktype, FBID: FBID, ContentID: ContentID, SubContentID: SubContentID, Answer: Answer, CorrectAnswer: CorrectAnswer, WatchType: WatchType, WatchTime: WatchTime, DeviceID: DeviceID, TaskStatus: TaskStatus, Current_Points: Current_Points, Points: Points, Prev_Points
        : Prev_Points) { (result, error) in
            self.hideSpinner()
            if error == nil {
                if let statusCode = result!["StatusCode"].int {
                    if statusCode == 2 {
                        if let points = result!["Points"].int {
                            switch self.selectedTask.code {
                            case 1, 2, 7, 8, 17 :
                                self.taskPoint = self.selectedTask.reward
                                
                            default :
                                self.taskPoint = "\(points - Int(self.user.points)!)"
                            }
                            
                            CoreDataManager.sharedInstance.updateUserPoints(withPoints: "\(points)", completionHandler: { (coreResult) in
                                DispatchQueue.main.async {
                                    self.contentDuration = ""
                                    self.contentID = ""
                                    self.showSuccessModal(totalPoints: "\(points)")
                                }
                            })
                        }
                    }else {
                        //show alert
                        self.presentDefaultAlertWithMessage(message: "Something went wrong!")
                    }
                }
            }else {
                // Show alert
                self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let task = sender as! TaskModel
        if let controller = segue.destination as? WebViewTaskViewController {
            var url = ""
            switch task.type {
            case 1:
                url = "https://ngage.ph/web/Home/Profile?fbid={fbid}"
                url = url.replacingOccurrences(of: "{fbid}", with: "\(user.facebookId)")
                break
                
            case 2:
                url = "https://ngage.ph/web/Home/Survey?MID={MID}&TID={TID}&TTyID={TTyID}&CID={CID}&FBID={FBID}&DID={DID}"
                print("URL = \(url)")
                url = url.replacingOccurrences(of: "{MID}", with: "\(mission.code)")
                url = url.replacingOccurrences(of: "{TID}", with: "\(task.code)")
                url = url.replacingOccurrences(of: "{TTyID}", with: "\(task.type)")
                url = url.replacingOccurrences(of: "{CID}", with: task.contentId)
                url = url.replacingOccurrences(of: "{FBID}", with: "\(user.facebookId)")
                url = url.replacingOccurrences(of: "{DID}", with: "\(user.deviceID)")
                break
                
            case 12, 13, 14, 15:
                url = "https://ngage.ph/web/Home/ProfileQuest?MID={MID}&TID={TID}&TTyID={TTyID}&CID={CID}&FBID={FBID}&DID={DID}"
                url = url.replacingOccurrences(of: "{MID}", with: "\(mission.code)")
                url = url.replacingOccurrences(of: "{TID}", with: "\(task.code)")
                url = url.replacingOccurrences(of: "{TTyID}", with: "\(task.type)")
                url = url.replacingOccurrences(of: "{CID}", with: task.contentId)
                url = url.replacingOccurrences(of: "{FBID}", with: "\(user.facebookId)")
                url = url.replacingOccurrences(of: "{DID}", with: "\(user.deviceID)")
                break
            
            default:
                break
            }
            controller.task = task
            controller.mission = mission
            controller.webLink = url
            controller.delegate = self
        }else if let controller = segue.destination as? TaskInstructionsViewController {
            controller.mission = mission
            controller.task = task
        }else if let controller = segue.destination as? TasksCompletedViewController {
            controller.delegate = self
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.taskUpdated(tasks: tasks)
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension TaskViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        if task.state == TaskStatus.enabled.rawValue {
            selectedTask = task
            selectedIndex = indexPath.row
            customView.isHidden = false
            let modalView = Bundle.main.loadNibNamed("CustomModalView", owner: self, options: nil)?.first as! CustomModalView
            modalView.tag = 1
            modalView.delegate = self
            modalView.setupContent(value: task.instructions)
            modalView.bounds = customView.bounds
            modalView.frame.origin = CGPoint(x: 0, y: 0)
            customView.addSubview(modalView)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension TaskViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        let color = UIColor().setColorUsingHex(hex: mission.colorBackground)
        cell.setupUsing(task: tasks[indexPath.row], color: color)
        return cell
    }
}


extension TaskViewController : TaskDoneDelegate {
    func didFinishedTask(task: TaskModel) {
        didFinishTask(task: task)
    }
}

// MARK: - Custom Modal View Delegate
extension TaskViewController : CustomModalViewDelegate {
    func didTapOkayButton(tag: Int) {
        customView.isHidden = true
        for views in customView.subviews {
            views.removeFromSuperview()
        }
        if tag == 1 {
            openTask()
        }else if tag == 2 {
            adjustTasks()
        }else if tag == 13 {
            
        }
    }
}

extension TaskViewController : TasksCompletedViewControllerDelegate {
    func didCloseCompletedController() {
        self.getRewardPoints()
    }
}

//MARK: - Scratch view Delegate
extension TaskViewController : ScratchUIViewDelegate {
    
    func scratchEnded(_ view: ScratchUIView) {
        
        if self.customScratch!.getScratchPercent() > 50.0 && !self.didShowSuccessRedeem {
            self.showSuccessRedeemModal()
        }
    }
}
