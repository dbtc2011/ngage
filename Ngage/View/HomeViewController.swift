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
    var downloadsSession: URLSession?
    var user = UserModel().mainUser()
    var selectedIndex = 0
    @IBOutlet weak var buttonDrawer: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getMission()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
    
    func getMission() {
        
        RegisterService.getMissionList(fbid: self.user.facebookId) { (result, error) in
            print(result)
            print(error as Any)
            if error == nil {
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
                            for task in tasks {
                                var taskModel = TaskModel()
                                taskModel.state = task["taskState"].int ?? 0
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
                                taskModel.info = task["taskInfo"].string ?? ""
                                taskModel.rewardType = "\(task["taskRewardType"].int ?? 0)"
                                missionModel.tasks.append(taskModel)
                            }
                        }
                        self.user.missions.append(missionModel)
                        if mission == missions.last {
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                    
                }
                
            }else {
                
            }
        }
        
        RegisterService.getLoadList(telco: "GLOBE") { (result, error) in
            
            print("Load list = \(result) - error = \(error)")
        }
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
            controller.mission = mission
        }
    }
    

}

extension HomeViewController : UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.user.missions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionCell", for: indexPath) as! HomeCollectionViewCell
        cell.delegate = self
        let mission = self.user.missions[indexPath.row]
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
