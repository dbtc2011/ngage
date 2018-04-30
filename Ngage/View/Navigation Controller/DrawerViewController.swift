//
//  DrawerViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var tblMenu: UITableView!
    
    var user = UserModel().mainUser()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //dummy data
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = UserModel().mainUser()
        tblMenu.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    func showViewController(withIdentifier identifier: String, fromStoryboard storyboard: String, link: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        if let controller = viewController as? DrawerWebViewController {
            controller.webLink = link
            present(controller, animated: false, completion: nil)
        } else if let controller = viewController as? ReferralCodeViewController {
            controller.delegate = self
            controller.origin = .drawer
            controller.user = self.user
            present(controller, animated: false, completion: nil)
        } else {
            present(viewController, animated: false, completion: nil)
        }
    }
}

extension DrawerViewController: ReferralCodeViewControllerDelegate {
    func didEnterReferredBy(value: String) {
        if value == "" {
            return
        }
        self.user.refferedBy = value
        self.tblMenu.reloadData()
        
        if let drawer = self.parent as? KYDrawerController {
            drawer.setDrawerState(.opened, animated: true)
        }
        
    }
}

extension DrawerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section > 0 else { return }
        var displayingController: UIViewController?
        if let drawer = parent as? KYDrawerController {
            if indexPath.section == 2 && indexPath.row == 0 {
                UserDefaults.standard.set(true, forKey: Keys.reloadData)
            }
            drawer.setDrawerState(.closed, animated: true)
            displayingController = drawer.mainViewController
            
        }
        var link = ""
        var identifier = "MarketNavigation"
        var storyboard = "Main"
        
        switch indexPath.row {
        case 0:
            
            return
            
        case 1:
            if indexPath.section == 1 {
                identifier = "MarketNavigation"
                storyboard = "RedeemStoryboard"
            } else if indexPath.section == 2 {
                identifier = "referralVC"
                storyboard = "Main"
                
            } else {
                return
            }
            
        case 2 :
            if indexPath.section == 1 {
                identifier = "NotificationNavi"
                storyboard = "HomeStoryboard"
            } else {
                return
            }
           
        case 3:
            identifier = "HistoryNavi"
            storyboard = "HomeStoryboard"
            
        default:
            return
        }
        self.showViewController(withIdentifier: identifier, fromStoryboard: storyboard, link: link)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140.0
        }
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
            
        case 1:
            return 10.0
            
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
            
        case 1:
            return UIView()
            
        default:
            let viewOthersHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
            
            let viewLine = UIView(frame: CGRect(x: 0, y: 10, width: viewOthersHeader.frame.width, height: 2.0))
            viewLine.backgroundColor = UIColor.groupTableViewBackground
            viewOthersHeader.addSubview(viewLine)
            
            let lblOthers = UILabel(frame: CGRect(x: 15.0, y: viewLine.frame.maxY + 10.0, width: viewOthersHeader.frame.width - 30.0, height: 20.0))
            lblOthers.text = "Others"
            lblOthers.textColor = UIColor.gray
            viewOthersHeader.addSubview(lblOthers)
            
            return viewOthersHeader
        }
    }
}

extension DrawerViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 4
            
        default:
            if user.refferedBy.isEmpty {
                return 2
            }
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
            cell.setProfileInfo(withUserModel: user)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawerCell") as! DrawerTableViewCell
        var title = ""
        var image = UIImage()
        
        switch indexPath.row {
        case 0:
            if indexPath.section == 1 {
                title = "Home"
                image = #imageLiteral(resourceName: "ic_action_home")
            } else {
                title = "Refresh"
                image = UIImage(named: "ic_action_refresh") ?? #imageLiteral(resourceName: "ic_action_about_us")
            }
            
        case 1:
            if indexPath.section == 1 {
                title = "Market Place"
                image = #imageLiteral(resourceName: "ic_action_rewards")
            } else {
                title = "Enter Referral"
                image = #imageLiteral(resourceName: "ic_menu").tint(with: UIColor.lightGray)
            }
            
        case 2:
            title = "Notifications"
            image = #imageLiteral(resourceName: "ic_action_achievements")
            
        default:
            title = "History"
            image = #imageLiteral(resourceName: "ic_action_history")
        }
        
        cell.setup(withTitle: title, withImage: image)
        
        return cell
    }
}
