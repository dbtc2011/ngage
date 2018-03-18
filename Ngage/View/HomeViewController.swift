//
//  HomeViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: DrawerFrontViewController {
    var shouldReloadData = false
    var downloadsSession: URLSession?
    var user = UserModel().mainUser()
    var selectedIndex = 0
    var shouldReloadTime = true
    @IBOutlet weak var buttonDrawer: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIColor(color: UIColor.lightGray)
        setupUI()
        getMission()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldReloadTime = true
        if user.missions.count == 0 {
            shouldReloadTime = false
        }
        reloadTime()
        if shouldReloadData == true {
            getMission()
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View did disappear")
        shouldReloadTime = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //taskPage
    //MARK: - Function
    func setupUI() {
        downloadsSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        buttonDrawer.addTarget(self, action: #selector(toggleDrawer(_:)), for: UIControlEvents.touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(toggleDrawer(_:)))
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    func setUIColor(color : UIColor) {
        self.view.backgroundColor = color
        self.collectionView.backgroundColor = color
        Util.setNavigationBar(color: color)
        navigationController?.navigationBar.barTintColor = color
    }
    
    func reloadMissionData() {
        var missionIndex = 0
        for mission in user.missions {
            var missionModel = mission
            missionModel = self.lockMissionForStarter(mission: missionModel)
            var taskCounter = 0
            var taskIndex = 0
            for task in mission.tasks {
                let taskModel = task
                if taskModel.state == 2 {
                    taskCounter = taskCounter + 1
                }
                if taskCounter == missionModel.tasks.count {
                    if missionModel.code == 1 {
                        TimeManager.sharedInstance.hasFinishedFirstTask = true
                    }
                    missionModel.state = MissionState.completed
                }
                missionModel.tasks[taskIndex] = taskModel
                taskIndex = taskIndex + 1
            }
            if taskCounter > 0 && taskCounter < mission.tasks.count {
                missionModel.state = MissionState.started
            }
            self.user.missions[missionIndex] = missionModel
            missionIndex = missionIndex + 1
        }
    }
    
    func reloadTime() {
        if shouldReloadTime {
            reloadMissionData()
            if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? HomeCollectionViewCell {
                let mission = self.user.missions[selectedIndex]
                cell.setupContents(mission: mission)
                cell.updateTime()
                
            }
            
            if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex-1, section: 0)) as? HomeCollectionViewCell {
                let mission = self.user.missions[selectedIndex-1]
                cell.setupContents(mission: mission)
                cell.updateTime()
                
            }
            
            if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex+1, section: 0)) as? HomeCollectionViewCell {
                let mission = self.user.missions[selectedIndex+1]
                cell.setupContents(mission: mission)
                cell.updateTime()
                
            }
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.reloadTime()
            }
        }
    
    }
    
    //MARK: - API
    
    func getMission() {
        RegisterService.getMissionList(fbid: self.user.facebookId) { (result, error) in
            self.shouldReloadTime = true
            if error == nil {
                self.shouldReloadData = false
                if let missions = result?["missions"].array {
                    self.user.missions.removeAll()
                    for mission in missions {
                        var missionModel = MissionModel()
                        missionModel.code = mission["missionCode"].int ?? 0
                        missionModel.colorPrimary = mission["missionPrimaryColor"].string ?? ""
                        missionModel.colorSecondary = mission["missionSecondaryColor"].string ?? ""
                        missionModel.colorBackground = mission["missionBackground"].string ?? ""
                        missionModel.startDate = mission["missionStartDate"].string ?? ""
                        missionModel.reward = "\(mission["missionReward"].int ?? 0)"
                        missionModel.isClaimed = mission["isClaim"].bool ?? false
                        missionModel.brand = mission["missionBrand"].string ?? ""
                        missionModel.rewardInfo = mission["missionRewardInfo"].string ?? ""
                        missionModel.rewardDetails = mission["missionRewardDet"].string ?? ""
                        missionModel.pointsRequiredToUnlock = mission["missionUnlock"].string ?? ""
                        missionModel.createdBy = mission["missionCreatedBy"].string ?? ""
                        missionModel.title = mission["missionTitle"].string ?? ""
                        missionModel.imageUrl = mission["missionImage"].string ?? ""
                        missionModel.imageTask = DownloadImageClass(link: missionModel.imageUrl)
                        
                        if let tasks = mission["tasks"].array {
                            var taskCounter = 0
                            for task in tasks {
                                var taskModel = TaskModel()
                                taskModel.state = task["taskState"].int ?? 0
                                taskModel.info = task["taskInfo"].string ?? ""
                                if taskModel.state == 2 {
                                    taskCounter = taskCounter + 1
                                }
                                if taskCounter == tasks.count {
                                    if missionModel.code == 1 {
                                       TimeManager.sharedInstance.hasFinishedFirstTask = true
                                    }
                                    missionModel.state = MissionState.completed
                                }
                                taskModel.code = task["taskCode"].int ?? 0
                                taskModel.instructions = task["taskInstruction"].string ?? ""
                                taskModel.type = task["taskType"].int ?? 0
                                taskModel.reward = "\(task["taskReward"].int ?? 0)"
                                taskModel.title = task["taskTitle"].string ?? ""
                                taskModel.rewardInfo = task["taskRewardInfo"].string ?? ""
                                taskModel.contentId = task["taskContentID"].string ?? ""
                                taskModel.isReward = "\(task["isReward"].int ?? 0)"
                                taskModel.rewardDetails = task["taskRewardDetails"].string ?? ""
                                taskModel.isClaimed = task["isClaim"].bool ?? false
                                taskModel.detail = task["taskDetail"].string ?? ""
                                taskModel.rewardType = "\(task["taskRewardType"].int ?? 0)"
                                missionModel.tasks.append(taskModel)
                            }
                            if taskCounter > 0 && taskCounter < tasks.count {
                                missionModel.state = MissionState.started
                            }
                            
                        }
                        
                        missionModel = self.lockMissionForStarter(mission: missionModel)
                        self.user.missions.append(missionModel)
                        if mission == missions.last {
                            TimeManager.sharedInstance.shouldEditMission = false
                            DispatchQueue.main.async {
                                self.shouldReloadTime = true
                                self.collectionView.reloadData()
                                let when = DispatchTime.now() + 1.0
                                DispatchQueue.main.asyncAfter(deadline: when) {
                                    self.reloadTime()
                                }
                            }
                        }
                    }
                    
                }
                
            }else {
                
            }
        }
    
    }
    
    func lockMissionForStarter(mission: MissionModel) -> MissionModel {
        var newMission = mission
        if let hasStarted = UserDefaults.standard.bool(forKey: Keys.keyHasStartedMission) as? Bool{
            if hasStarted {
                let missionStarted = UserDefaults.standard.value(forKey: Keys.keyMissionCode) as! Int
                if newMission.code != missionStarted && newMission.code != 1 {
                    newMission.state = MissionState.locked
                }
            }else {
                if !TimeManager.sharedInstance.hasFinishedFirstTask && newMission.code != 1 {
                    newMission.state = MissionState.locked
                    print("Mission should lock = \(newMission.brand)")
                }
            }
        }else {
            if !TimeManager.sharedInstance.hasFinishedFirstTask && newMission.code != 1 {
                newMission.state = MissionState.locked
            }
        }
        return newMission
    }
    
    //MARK: - Button action

    @IBAction func drawerClicked(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let controller = segue.destination as? TaskViewController {
            let mission = self.user.missions[selectedIndex]
            controller.delegate = self
            controller.mission = mission
        }
    }
    

}

extension HomeViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.user.missions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionCell", for: indexPath) as! HomeCollectionViewCell
        cell.delegate = self
        let mission = self.user.missions[indexPath.row]
        print("Mission state = \(mission.state)")
        cell.setupContents(mission: mission)
        if mission.imageTask!.state == DowloadingImageState.new {
            let url = URL(string: mission.imageUrl)
            mission.imageTask!.downloadTask = self.downloadsSession!.downloadTask(with: url!)
            mission.imageTask!.taskIdentifier = (mission.imageTask!.downloadTask!.taskIdentifier)
            mission.imageTask!.state = DowloadingImageState.downloading
            mission.imageTask!.downloadTask!.resume()
        }
        
        return cell
        
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        let collectionViewCell = cell as! HomeCollectionViewCell
//        collectionViewCell.updateTime()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height-50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension HomeViewController : UICollectionViewDelegate {
    
}

extension HomeViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll view = \(scrollView.contentOffset)")
        let index = scrollView.contentOffset.x/self.view.frame.size.width
        selectedIndex = Int(index)
        let color = UIColor().setColorUsingHex(hex: self.user.missions[selectedIndex].colorBackground)
        self.setUIColor(color: color)
        
    }
}
extension HomeViewController : HomeCollectionViewCellDelegate {
    
    func homeDidTapStart(tag: Int) {
        self.performSegue(withIdentifier: "taskPage", sender: self)
    }
}

//MARK: - NSURL Session
extension HomeViewController : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let index = self.user.missions.index { (mission) -> Bool in
            mission.imageTask!.taskIdentifier == downloadTask.taskIdentifier
        }
        if index != nil {
            let mission = self.user.missions[index!.hashValue]
            do {
                let data = try Data(contentsOf: location)
                let image = UIImage(data: data)
                if image != nil {
                    mission.imageTask!.state = DowloadingImageState.done
                    mission.imageTask!.data = data
                    self.user.missions[index!.hashValue] = mission
                    let indexPath = IndexPath(item: index!.hashValue, section: 0)
                    DispatchQueue.main.async {
                        let color = UIColor().setColorUsingHex(hex: self.user.missions[self.selectedIndex].colorBackground)
                        self.setUIColor(color: color)
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }else {
                    mission.imageTask!.state = DowloadingImageState.new
                }
                
            } catch {
                print(error.localizedDescription)
                mission.imageTask!.state = DowloadingImageState.new
            }
        }
    
    }
}
extension HomeViewController : TaskViewControllerDelegate {
    func mustReloadData() {
        shouldReloadData = true
    }
    
    func taskUpdated(tasks: [TaskModel]) {
        var mission = user.missions[selectedIndex]
        mission.tasks = tasks.reversed()
        if let task = tasks.first {
            if task.state == 2 {
                mission.state = MissionState.completed
            }
        }else if let task = tasks.last {
            if task.state == 2 {
                mission.state = MissionState.started
            }
        }
        user.missions[selectedIndex] = mission
    }
}
