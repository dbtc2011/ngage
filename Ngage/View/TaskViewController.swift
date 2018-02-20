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

class TaskViewController: UIViewController {

    @IBOutlet weak var progress: UICircularProgressRingView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var mission: MissionModel!
    var tasks : [TaskModel] = []
    var user = UserModel().mainUser()
    var selectedTask : TaskModel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = mission.tasks.reversed()
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
        let storyBoard = UIStoryboard(name: "Tasks", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "InstallTaskViewController") as? InstallTaskViewController {
            controller.task = task
            controller.mission = mission
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func didFinishTask(task: TaskModel) {
        
        print("Finished task \(task.info)")
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
        }else if let controller = segue.destination as? TaskInstructionsViewController {
            controller.mission = mission
            controller.task = task
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension TaskViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        if task.state == TaskStatus.enabled.rawValue {
            selectedTask = task
            switch task.type {
            case 1, 2, 12, 13, 14, 15:
                performSegue(withIdentifier: "webViewTask", sender: task)
            case 3:
                playVideo(task: task)
            case 5:
                facebookShare(task: task)
                
            case 6:
                openContactList(task: task)
                
            case 7, 8, 17:
                openQuestionaireWithMusic(task: task)
                
            case 9:
                installTask(task: task)
                
            case 10:
                showPhotoPopOver()
                
            default:
                break
            }
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

