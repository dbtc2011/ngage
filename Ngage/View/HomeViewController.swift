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
  public var shouldReloadData = false
  var downloadsSession: URLSession?
  var user = UserModel().mainUser()
  var selectedIndex = 0
  var finishedMission = 0
  var shouldReloadTime = true
  var shouldShowMarketAds = false
  @IBOutlet weak var buttonDrawer: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  var marketAds: MarketPlaceAdsView?
  var customAlertView: CustomModalView?
  @IBOutlet weak var pageController: UIPageControl!
  @IBOutlet weak var pageTopConstraints: NSLayoutConstraint!
  
  @IBOutlet weak var buttonTutorial: UIButton!
  @IBOutlet weak var viewTutorial: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDataFromCoreData()
    setupBackgroundProfile()
    setupUI()
    getMission()
    collectionView.delegate = self
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let newUser = UserModel().mainUser()
    self.user.points = newUser.points
    self.user.availableMissions = newUser.availableMissions
    shouldReloadTime = true
    showMarketAds()
    if user.missions.count == 0 {
      shouldReloadTime = false
    }
    
    if #available(iOS 11.0, *) {
      let window = UIApplication.shared.keyWindow
      let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
//      let topPadding = window?.safeAreaInsets.top ?? 0.0
      pageTopConstraints.constant = pageTopConstraints.constant - (bottomPadding/2)
    }
    reloadTime()
    if shouldReloadData == true {
      getMission()
    }
    
    if let didTapReload = UserDefaults.standard.value(forKey: Keys.reloadData) as? Bool, didTapReload == true {
      getMission()
    }
    print("Did tap \(UserDefaults.standard.value(forKey: Keys.reloadData))")
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
  func setupDataFromCoreData() {
    CoreDataManager.sharedInstance.fetchSavedObjects(forEntity: .Mission) { (result, data) in
      if let contents = data as? [MissionModel] {
        for mission in contents {
          var missionModel = mission
          missionModel.imageTask = DownloadImageClass(link: missionModel.imageUrl)
          let taskDatas = CoreDataManager.sharedInstance.fetchTaskForMission(code: mission.code)
          for taskData in taskDatas {
            missionModel.tasks.append(taskData)
          }
          self.user.missions.append(missionModel)
        }
        self.pageController.numberOfPages = self.user.missions.count + 1
      }
      
    }
    
  }
  func setupUI() {
    downloadsSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    buttonDrawer.addTarget(self, action: #selector(toggleDrawer(_:)), for: UIControlEvents.touchUpInside)
    //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(toggleDrawer(_:)))
    //        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    self.collectionView.register(UINib(nibName:"ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "profileCell")
    self.collectionView.register(UINib(nibName:"HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "missionCell")
  }
  
  func showMarketAds() {
    if !shouldShowMarketAds {
      return
    }
    shouldShowMarketAds = false
    user.points = UserModel().mainUser().points
    marketAds = Bundle.main.loadNibNamed("MarketPlaceAdsView", owner: self, options: nil)?.first as? MarketPlaceAdsView
    marketAds!.delegate = self
    marketAds!.setupContent(points: user.points, title: "Lets get started")
    marketAds!.bounds = UIScreen.main.bounds
    marketAds!.frame.origin = CGPoint(x: 0, y: 0)
    if let window = UIApplication.shared.keyWindow {
      window.addSubview(marketAds!)
    }
  }
  
  func showCustomAlertWith(message: String, tag: Int) {
    customAlertView = Bundle.main.loadNibNamed("CustomModalView", owner: self, options: nil)?.first as! CustomModalView
    customAlertView!.delegate = self
    customAlertView!.tag = tag
    customAlertView?.titleHeightConstraint.constant = 0
    customAlertView!.icon.image = UIImage(named: "ic_app_logo_circle")
    customAlertView!.setupContent(value: message)
    customAlertView!.button.setTitle("Ok", for: UIControlState.normal)
    customAlertView!.bounds = UIScreen.main.bounds
    customAlertView!.frame.origin = CGPoint(x: 0, y: 0)
    if let window = UIApplication.shared.keyWindow {
      window.addSubview(customAlertView!)
    }
  }
  
  func showPopupBeforeUnlockingMission() {
    if customAlertView != nil {
      customAlertView!.removeFromSuperview()
      customAlertView = nil
    }
    customAlertView = Bundle.main.loadNibNamed("CustomModalView", owner: self, options: nil)?.first as! CustomModalView
    customAlertView!.delegate = self
    customAlertView!.tag = 1
    customAlertView!.buttonExtra.setTitle("Cancel", for: UIControlState.normal)
    customAlertView?.buttonExtra.tag = 1
    customAlertView?.button.tag = 2
    customAlertView!.icon.image = UIImage(named: "ic_app_logo_circle")
    customAlertView!.setupContent(value: "This mission require 10 points to unlock. Unlock mission?")
    customAlertView!.button.setTitle("Unlock", for: UIControlState.normal)
    customAlertView!.bounds = UIScreen.main.bounds
    customAlertView!.frame.origin = CGPoint(x: 0, y: 0)
    if let window = UIApplication.shared.keyWindow {
      window.addSubview(customAlertView!)
    }
  }
  
  func removeMarketAds() {
    if self.marketAds != nil {
      self.marketAds!.removeFromSuperview()
      self.marketAds = nil
    }
  }
  
  func setupBackgroundProfile() {
    let color = UIColor(red: 22.0/255.0, green: 47.0/255.0, blue: 94.0/255.0, alpha: 1)
    self.setUIColor(color: color)
    /*
     // Fucking waste of time. Change of UI
     if let imageView = view.viewWithTag(13) as? UIImageView {
     return
     }
     self.removeProfileBackground()
     self.collectionView.backgroundColor = UIColor.clear
     var profileImage: UIImage?
     if let data = user.image {
     profileImage = UIImage(data: data)
     }else if let data = UserDefaults.standard.value(forKeyPath: "profile_image") as? Data {
     profileImage = UIImage(data: data)
     }
     if profileImage != nil {
     DispatchQueue.main.async {
     let backgroundImageView = UIImageView()
     backgroundImageView.frame = self.view.bounds
     backgroundImageView.image = profileImage!
     backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
     backgroundImageView.tag = 13
     
     let imageDark = UIImageView()
     imageDark.frame = self.view.bounds
     imageDark.backgroundColor = UIColor.black
     imageDark.alpha = 0.6
     backgroundImageView.addSubview(imageDark)
     
     self.view.insertSubview(backgroundImageView, at: 0)
     }
     }
     */
  }
  func setUIColor(color : UIColor) {
    self.view.backgroundColor = color
    self.collectionView.backgroundColor = color
    Util.setNavigationBar(color: color)
    navigationController?.navigationBar.barTintColor = color
  }
  
  func removeProfileBackground() {
    if let imageView = view.viewWithTag(13) as? UIImageView {
      imageView.removeFromSuperview()
    }
  }
  func setupTutorial() {
    UserDefaults.standard.set(true, forKey: Keys.hasFinishedTutorial)
    viewTutorial.isHidden = false
    buttonTutorial.layer.cornerRadius = 5
    buttonTutorial.backgroundColor = UIColor().setColorUsingHex(hex: user.missions[0].colorBackground)
    buttonTutorial.isUserInteractionEnabled = false
  }
  
  func reloadMissionData() {
    var missionIndex = 0
    var shouldLockMissions = false
    finishedMission = 0
    for mission in user.missions {
      var missionModel = mission
      missionModel = self.lockMissionForStarter(mission: missionModel)
      var taskCounter = 0
      var taskIndex = 0
      for task in mission.tasks {
        var taskModel = task
        if taskModel.state == 2 {
          taskCounter = taskCounter + 1
        }
        if taskCounter == missionModel.tasks.count {
          if missionModel.code == 1 {
            TimeManager.sharedInstance.hasFinishedFirstTask = true
          }
          missionModel.state = MissionState.completed
          finishedMission = finishedMission + 1
        }
        if TimeManager.sharedInstance.hasFinishedFirstTask == false && missionIndex != 0 {
          taskModel.state = 0
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
      if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 1)) as? HomeCollectionViewCell {
        let mission = self.user.missions[selectedIndex]
        print("Model's state = \(mission.state)")
        cell.setupContents(mission: mission)
        cell.updateTime(mission: mission)
      }
      
      if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex-1, section: 1)) as? HomeCollectionViewCell {
        let mission = self.user.missions[selectedIndex-1]
        print("Model's state = \(mission.state)")
        cell.setupContents(mission: mission)
        cell.updateTime(mission: mission)
        
      }
      
      if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex+1, section: 1)) as? HomeCollectionViewCell {
        let mission = self.user.missions[selectedIndex+1]
        print("Model's state = \(mission.state)")
        cell.setupContents(mission: mission)
        cell.updateTime(mission: mission)
        
      }
      let when = DispatchTime.now() + 1
      DispatchQueue.main.asyncAfter(deadline: when) {
        self.reloadTime()
      }
    }
    
  }
  
  func openWebPageWithLink(link: String) {
    let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "DrawerWebViewController")
    
    if let controller = viewController as? DrawerWebViewController {
      controller.webLink = link
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  //MARK: - API
  func getMission() {
    showSpinner()
    RegisterService.getMissionList(fbid: self.user.facebookId) { (result, error) in
      self.hideSpinner()
      self.shouldReloadTime = true
      print("Result \(result)")
      if error == nil {
        if let missions = result?["missions"].array {
          for mission in missions {
            var missionModel = MissionModel()
            missionModel.code = mission["missionCode"].int ?? 0
            missionModel.colorPrimary = mission["missionPrimaryColor"].string ?? ""
            missionModel.colorSecondary = mission["missionSecondaryColor"].string ?? ""
            missionModel.colorBackground = mission["missionBackground"].string ?? ""
            missionModel.startDate = mission["missionStartDate"].string ?? ""
            missionModel.endDate = mission["missionEndDate"].string ?? ""
            missionModel.reward = "\(mission["missionReward"].int ?? 0)"
            missionModel.isClaimed = mission["isClaim"].bool ?? false
            missionModel.brand = mission["missionBrand"].string ?? ""
            missionModel.rewardInfo = mission["missionRewardInfo"].string ?? ""
            missionModel.rewardDetails = mission["missionRewardDet"].string ?? ""
            missionModel.pointsRequiredToUnlock = mission["missionUnlock"].string ?? ""
            missionModel.createdBy = mission["missionCreatedBy"].string ?? ""
            missionModel.title = mission["missionTitle"].string ?? ""
            missionModel.imageUrl = mission["missionImage"].string ?? ""
            print("Mission : \(missionModel.code) - \(missionModel.title)")
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
                taskModel.missionCode = missionModel.code
                taskModel.reward = "\(task["taskReward"].int ?? 0)"
                taskModel.title = task["taskTitle"].string ?? ""
                taskModel.rewardInfo = task["taskRewardInfo"].string ?? ""
                taskModel.contentId = task["taskContentID"].string ?? "1"
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
            print("Check mission if existing")
            if CoreDataManager.sharedInstance.checkMissionExist(code: missionModel.code) {
              if self.shouldReloadData {
                CoreDataManager.sharedInstance.saveModelToCoreData(withModel: missionModel as AnyObject, completionHandler: { (result) in
                })
              }
              
              print("Mission already exist, do not update")
            }else {
              CoreDataManager.sharedInstance.saveModelToCoreData(withModel: missionModel as AnyObject, completionHandler: { (result) in
                
              })
              self.user.missions.append(missionModel)
            }
            if mission == missions.last {
              TimeManager.sharedInstance.shouldEditMission = false
              DispatchQueue.main.async {
                self.shouldReloadTime = true
                self.collectionView.reloadData()
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                  self.reloadTime()
                  self.removeProfileBackground()
                  self.pageController.numberOfPages = self.user.missions.count + 1
                  self.pageController.currentPage = 1
                  self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: UICollectionViewScrollPosition.left, animated: false)
                  if let hasFinished = UserDefaults.standard.bool(forKey: Keys.hasFinishedTutorial) as? Bool {
                    if hasFinished {
                      return
                    }
                  }
                  self.setupTutorial()
                }
              }
            }
          }
        }
        
        self.shouldReloadData = false
        UserDefaults.standard.set(false, forKey: Keys.reloadData)
      }else {
        self.getMission()
      }
    }
    
  }
  
  func checkMissionAvailability(code: Int, tag: Int) {
    showSpinner()
    RegisterService.checkMissionAvailability(FBID: user.facebookId, MissionID: code) { (result, error) in
      self.hideSpinner()
      var errorDesc = result?["StatusDesc"].string ?? "Something went wrong!"
      let statusCode = result?["StatusCode"].int
      if error != nil {
        self.showCustomAlertWith(message: errorDesc, tag: 1)
      } else {
        //should be 2
        if statusCode == 2 {
          if tag == 1 {
            self.performSegue(withIdentifier: "taskPage", sender: self)
          }else {
            self.showPopupBeforeUnlockingMission()
          }
          return
          //should be 1
        } else if statusCode == 1 {
          errorDesc = "Sorry! This mission has already reached its maximum user. Please try other mission."
        } else if statusCode == 3 || statusCode == 0 {
          errorDesc = "Sorry! Mission has already expired."
        }
        var mission = self.user.missions[self.selectedIndex]
        mission.state = .disabled
        CoreDataManager.sharedInstance.saveModelToCoreData(withModel: mission as AnyObject, completionHandler: { (result) in
          UserDefaults.standard.set(false, forKey: Keys.shouldResetDisabled)
          self.user.missions[self.selectedIndex] = mission
          let indexPath = IndexPath(item: self.selectedIndex, section: 1)
          DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
            self.showCustomAlertWith(message: errorDesc, tag: 1)
          }
        })
        
      }
    }
  }
  
  func lockMissionForStarter(mission: MissionModel) -> MissionModel {
    var newMission = mission
    let shouldReset: Bool = UserDefaults.standard.value(forKey: Keys.shouldResetDisabled) as? Bool ?? true
    if let hasStarted = UserDefaults.standard.bool(forKey: Keys.keyHasStartedMission) as? Bool{
      if hasStarted {
        if !user.availableMissions.contains(newMission.code) && newMission.code != 1 {
          newMission.state = MissionState.locked
        } else {
          if !shouldReset && mission.state == .disabled {
            newMission.state = .disabled
          } else {
            newMission.state = .enabled
          }
        }
      }else {
        if !TimeManager.sharedInstance.hasFinishedFirstTask && newMission.code != 1 {
          newMission.state = MissionState.locked
        }else {
          if !shouldReset && mission.state == .disabled {
            newMission.state = .disabled
          } else {
            newMission.state = .enabled
          }
        }
      }
    }else {
      if !TimeManager.sharedInstance.hasFinishedFirstTask && newMission.code != 1 {
        newMission.state = MissionState.locked
      }
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    if let dateExpiry = formatter.date(from: mission.endDate) {
      let dateToCompare = TimeManager.sharedInstance.serverDate ?? Date()
      if let expiryDifference = dateToCompare.timeIntervalSince(dateExpiry) as? Double, expiryDifference > 0 {
        newMission.state = .expired
      }
    }
    return newMission
  }
  
  //MARK: - Button action
  
  @IBAction func drawerClicked(_ sender: UIBarButtonItem) {
    
  }
  
  @IBAction func tutorialTap(_ sender: UITapGestureRecognizer) {
    viewTutorial.isHidden = true
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
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    return self.user.missions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.section == 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
      cell.setupUI(mission: finishedMission)
      cell.delegate = self
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionCell", for: indexPath) as! HomeCollectionViewCell
    cell.delegate = self
    let mission = self.user.missions[indexPath.row]
    cell.setupContents(mission: mission)
    print("Mission code = \(mission.code)")
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
    var height = UIScreen.main.bounds.size.height - 50
    if #available(iOS 11.0, *) {
      let window = UIApplication.shared.keyWindow
      let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
      let topPadding = window?.safeAreaInsets.top ?? 0.0
      height = height - bottomPadding - topPadding
    }
    
    return CGSize(width: self.view.frame.size.width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
extension HomeViewController : UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      return
    }
  }
  
}


extension HomeViewController : UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = scrollView.contentOffset.x/self.view.frame.size.width
    self.pageController.currentPage = Int(index)
    selectedIndex = Int(index)
    if selectedIndex == 0 {
      setupBackgroundProfile()
      self.pageController.isHidden = true
      return
    }
    self.pageController.isHidden = false
    self.removeProfileBackground()
    selectedIndex = selectedIndex - 1
    let color = UIColor().setColorUsingHex(hex: self.user.missions[selectedIndex].colorBackground)
    self.setUIColor(color: color)
    
  }
}
extension HomeViewController : HomeCollectionViewCellDelegate {
  
  func homeDidTapStart(tag: Int) {
    let mission = user.missions[selectedIndex]
    if mission.code == 1 {
      self.performSegue(withIdentifier: "taskPage", sender: self)
    } else if mission.state == .enabled {
      checkMissionAvailability(code: mission.code, tag: 1)
    } else {
      self.performSegue(withIdentifier: "taskPage", sender: self)
    }
  }
  
  func homeDidTapLock(tag: Int) {
    let mission = user.missions[selectedIndex]
    if mission.state == .disabled {
      return
    }
    if mission.state == .expired {
      self.showCustomAlertWith(message: "This mission is no longer available.", tag: 1)
      return
    }
    if !TimeManager.sharedInstance.hasFinishedFirstTask {
      self.showCustomAlertWith(message: "You have to first complete Let's get started to unlock this mission", tag: 1)
      return
    }
    if user.points.convertToInt() >= 10 {
      checkMissionAvailability(code: mission.code, tag: 14)
    } else {
      self.showCustomAlertWith(message: "This mission require 10 points to unlock.", tag: 1)
    }
  }
}

//MARK: - Custom Alert Delegate
extension HomeViewController : CustomModalViewDelegate {
  func didTapOkayButton(tag: Int) {
    if customAlertView != nil {
      customAlertView!.removeFromSuperview()
      customAlertView = nil
    }
    if tag == 2 {
      let mission = user.missions[selectedIndex]
      showSpinner()
      RegisterService.unlockMission(fbid: user.facebookId, mission: "\(mission.code)") { (result, error) in
        self.hideSpinner()
        print("Unlock mission")
        if let statusCode = result?["StatusCode"].int, statusCode == 2 {
          CoreDataManager.sharedInstance.addToUserAvailableMissions(withMissionCode: mission.code, completionHandler: { (result) in
            self.user.availableMissions = UserModel().mainUser().availableMissions
          })
          if let points = result?["Points"].int {
            
            CoreDataManager.sharedInstance.updateUserPoints(withPoints: "\(points)") { (result) in
              self.user.points = "\(points)"
            }
          }
          
        }else {
          
        }
      }
    }
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
          let indexPath = IndexPath(item: index!.hashValue, section: 1)
          DispatchQueue.main.async {
            let color = UIColor().setColorUsingHex(hex: self.user.missions[self.selectedIndex].colorBackground)
            self.setUIColor(color: color)
            self.collectionView.reloadItems(at: [indexPath])
          }
        }else {
          mission.imageTask!.state = DowloadingImageState.new
        }
        
      } catch {
        mission.imageTask!.state = DowloadingImageState.new
      }
    }
    
  }
}

extension HomeViewController : TaskViewControllerDelegate {
  func mustReloadData() {
    shouldReloadData = true
  }
  
  func mustShowMarketPlaceAds() {
    shouldShowMarketAds = true
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
    CoreDataManager.sharedInstance.saveModelToCoreData(withModel: mission as AnyObject) { (result) in
      
    }
  }
}

extension HomeViewController : MarketPlaceAdsViewDelegate {
  
  func marketPlaceDidClose() {
    self.removeMarketAds()
  }
  
  func marketPlaceShouldOpenMarketPlace() {
    self.removeMarketAds()
    let storyboard = UIStoryboard(name: "RedeemStoryboard", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "MarketNavigation")
    let transition = CATransition()
    transition.duration = 0.25
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromRight
    view.window!.layer.add(transition, forKey: kCATransition)
    present(viewController, animated: false, completion: nil)
  }
  
}

extension HomeViewController: ProfileCollectionViewCellDelegate {
  func profileShouldGetPoints(withCell cell: ProfileCollectionViewCell) {
    showSpinner()
    
    RegisterService.refreshPoints(fbid: self.user.facebookId) { (json, error) in
      self.hideSpinner()
      
      guard error == nil else {
        self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
        return
      }
      
      guard json != nil else {
        self.presentDefaultAlertWithMessage(message: "Unable to reload points")
        return
      }
      
      let resultDict = json!.dictionary
      guard resultDict != nil else {
        self.presentDefaultAlertWithMessage(message: "Unable to reload points")
        return
      }
      
      if let statusCode = resultDict!["StatusCode"], let castedStatusCode = statusCode.int {
        guard castedStatusCode == 2 else {
          self.presentDefaultAlertWithMessage(message: "Unable to reload points")
          return
        }
        
        if let points = resultDict!["Points"], let casted = points.int {
          let strCasted = "\(casted)"
          CoreDataManager.sharedInstance.updateUserPoints(withPoints: strCasted, completionHandler: { (result) in
            
          })
          
          self.user.points = strCasted
          DispatchQueue.main.async {
            cell.updatePoints(withPoints: strCasted)
          }
        }
      }
    }
  }
  
  func profileDidSelect(link: String) {
    switch link {
    case "about_us":
      performSegue(withIdentifier: "goToAboutPage", sender: self)
    case "faqs":
      openWebPageWithLink(link: "https://ngage.ph/faq.html")
    case "terms":
      openWebPageWithLink(link: "https://ngage.ph/tos_ngage.html")
    case "privacy":
      openWebPageWithLink(link: "https://ngage.ph/privacy_policy_ngage.html")
    default:
      openWebPageWithLink(link: "https://ngage.ph/privacy_policy_ngage.html")
    }
    
  }
  
}
