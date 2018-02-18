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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    func showViewController(withIdentifier identifier: String, fromStoryboard storyboard: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewController, animated: false, completion: nil)
    }
}

extension DrawerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        
        if let drawer = parent as? KYDrawerController {
            drawer.setDrawerState(.closed, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var identifier = "MarketNavigation"
        var storyboard = "Main"
        
        switch indexPath.row {
        case 0:
            if indexPath.section == 1 {
                return
            } else {
                return
            }
            
        case 1:
            if indexPath.section == 1 {
                identifier = "MarketNavigation"
                storyboard = "RedeemStoryboard"
            } else {
                return
            }
            
        case 2:
            identifier = "ProfileVC"
            storyboard = "HomeStoryboard"
            
        default:
            return
        }
        
        self.showViewController(withIdentifier: identifier, fromStoryboard: storyboard)
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
            return 5
            
        default:
            return 2
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
        let image = #imageLiteral(resourceName: "ic_menu")
        
        switch indexPath.row {
        case 0:
            if indexPath.section == 1 {
                title = "Home"
            } else {
                title = "About Us"
            }
            
        case 1:
            if indexPath.section == 1 {
                title = "Market Place"
            } else {
                title = "Private Policy"
            }
            
        case 2:
            title = "Profile"
            
        case 3:
            title = "Notifications"
            
        default:
            title = "History"
        }
        
        cell.setup(withTitle: title, withImage: image)
        
        return cell
    }
}
