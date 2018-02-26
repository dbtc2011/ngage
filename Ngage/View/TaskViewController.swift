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

enum TaskAppCode : Int {
    case updateProfile = 1
}
protocol TaskViewControllerDelegate {
    func taskUpdated(tasks: [TaskModel])
    func mustReloadData()
}
class TaskViewController: UIViewController {

    @IBOutlet weak var progress: UICircularProgressRingView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var mission: MissionModel!
    var tasks : [TaskModel] = []
    var user = UserModel().mainUser()
    var selectedTask : TaskModel!
    var selectedIndex = 0
    var delegate : TaskViewControllerDelegate?
    var quizAnswers: String!
    var quizCorrectAnswers: String!
    
    var contentID : String = ""
    var contentDuration : String = ""
    
    var customView : CustomModalView?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var shouldSetEnabled = false
        var arrayCounter = 0
        var tempTasks : [TaskModel] = []
        for taskReversed in mission.tasks {
            var taskToAdd = taskReversed
            if shouldSetEnabled && taskReversed.state == 0{
                taskToAdd.state = 1
                shouldSetEnabled = false
            }
            if taskReversed.state == 2 {
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
    func setupUI() {
        self.progress.setProgress(value: 0, animationDuration: 1)
        if mission.imageTask!.data != nil {
            if let imageData = UIImage(data: mission.imageTask!.data!) {
                backgroundImage.image = imageData
                
            }
        }
        backgroundImage.addBlurEffect()
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
//        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
//        if let controller = storyBoard.instantiateViewController(withIdentifier: "MultipleChoiceTaskViewController") as? MultipleChoiceTaskViewController {
//            controller.task = task
//            controller.mission = mission
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
        
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
    
    func adjustTasks() {
        
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
        }
        
    }
    
    func quizDidSet(answers: String, correctAnswers: String) {
        quizAnswers = answers
        quizCorrectAnswers = correctAnswers
    }
    
    func setContent(id: String, duration : String) {
        contentID = id
        contentDuration = duration
    }
    func didFinishTask(task: TaskModel) {
        print("Finished task \(task.info)")
        UserDefaults.standard.set(true, forKey: Keys.keyHasStartedMission)
        UserDefaults.standard.set(mission.code, forKey: Keys.keyMissionCode)
        if mission.code != 1 {
            TimeManager.sharedInstance.setTimer()
            TimeManager.sharedInstance.hasStartedMission = true
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
    
    func openTask() {
        switch self.selectedTask.type {
        case 1, 2, 12, 13, 14, 15:
            performSegue(withIdentifier: "webViewTask", sender: self.selectedTask)
        case 3:
            playVideo(task: self.selectedTask)
        case 5:
            facebookShare(task: self.selectedTask)
        case 6:
            openContactList(task: self.selectedTask)
        case 7, 8, 17:
            openQuestionaireWithMusic(task: self.selectedTask)
        case 9:
            installTask(task: self.selectedTask)
            
        case 10:
            showPhotoPopOver()
            
        default:
            break
        }
    }
    func submitTask(missionID: String, taskID: String, tasktype: String, FBID: String, ContentID: String, SubContentID: String, Answer: String, CorrectAnswer: String, WatchType: String, WatchTime: String, DeviceID: String, TaskStatus: String, Current_Points: String, Points: String, Prev_Points: String) {
        
        RegisterService.insertRecord(missionID: missionID, taskID: taskID, tasktype: tasktype, FBID: FBID, ContentID: ContentID, SubContentID: SubContentID, Answer: Answer, CorrectAnswer: CorrectAnswer, WatchType: WatchType, WatchTime: WatchTime, DeviceID: DeviceID, TaskStatus: TaskStatus, Current_Points: Current_Points, Points: Points, Prev_Points
        : Prev_Points) { (result, error) in
            
            if error == nil {
                if let statusCode = result!["StatusCode"].int {
                    if statusCode == 2 {
                        if let points = result!["Points"].int {
                            CoreDataManager.sharedInstance.updateUserPoints(withPoints: "\(points)", completionHandler: { (coreResult) in
                                DispatchQueue.main.async {
                                    self.contentDuration = ""
                                    self.contentID = ""
                                    self.adjustTasks()
                                }
                            })
                        }
                    }else {
                        //show alert
                    }
                }
            }else {
                // Show alert
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
                url = "https://ph.ngage.ph/web/Home/profile?fbid={fbid}"
                url = url.replacingOccurrences(of: "{fbid}", with: "\(user.facebookId)")
                break
                
            case 2:
                url = "https://ph.ngage.ph/web/Home/Survey?MID={MID}&TID={TID}&TTyID={TTyID}&CID={CID}&FBID={FBID}&DID={DID}"
                print("URL = \(url)")
                url = url.replacingOccurrences(of: "{MID}", with: "\(mission.code)")
                url = url.replacingOccurrences(of: "{TID}", with: "\(task.code)")
                url = url.replacingOccurrences(of: "{TTyID}", with: "\(task.type)")
                url = url.replacingOccurrences(of: "{CID}", with: task.contentId)
                url = url.replacingOccurrences(of: "{FBID}", with: "\(user.facebookId)")
                url = url.replacingOccurrences(of: "{DID}", with: "\(user.deviceID)")
                break
                
            case 12, 13, 14, 15:
                url = "https://ph.ngage.ph/web/Home/ProfileQuest?MID={MID}&TID={TID}&TTyID={TTyID}&CID={CID}&FBID={FBID}&DID={DID}"
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
            openTask()
//            if customView == nil {
//                customView = CustomModalView.instanceFromNib()
//                customView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//                customView!.delegate = self
//                customView!.setupContent(value: task.instructions)
//                UIApplication.shared.keyWindow!.addSubview(customView!)
//            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
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

extension TaskViewController : CustomModalViewDelegate {
    func didTapOkayButton() {
        customView!.removeFromSuperview()
        customView = nil
        openTask()
    }
}
