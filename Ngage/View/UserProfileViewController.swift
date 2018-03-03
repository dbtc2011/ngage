//
//  UserProfileViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 04/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var tblInfo: UITableView!
    
    var user = UserModel()
    
    private var toShowBasicInfo = true
    private var toShowOccupation = true
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        imgUser.layer.cornerRadius = imgUser.frame.width/2
        imgUser.layer.borderColor = self.view.backgroundColor!.cgColor
        imgUser.layer.borderWidth = 2.0
        imgUser.clipsToBounds = true
    }
    
    @objc func didTapHeader(gestureRecognizer: UIGestureRecognizer) {
        if let view = gestureRecognizer.view {
            if view.tag == 2 {
                toShowBasicInfo = !toShowBasicInfo
            } else {
                toShowOccupation = !toShowOccupation
            }
            
            tblInfo.reloadSections(IndexSet(integer: view.tag), with: .fade)
        }
    }

    //MARK: - IBAction Delegate
    
    @IBAction func backClicked(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}

extension UserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        } else if section == 2 {
            guard toShowBasicInfo else { return 0 }
            
            return 7
        }
        
        guard toShowOccupation else { return 0 }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let nameCell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            if let lblName = nameCell.viewWithTag(1) as? UILabel {
                lblName.text = user.name
            }
            
            return nameCell
        } else if indexPath.section == 1 {
            let pointsCell = tableView.dequeueReusableCell(withIdentifier: "pointsCell", for: indexPath) as! UserPointsTableViewCell
            pointsCell.setPointsInfo(withPoints: "0", withRedeemed: "0", withMissions: "0")
            
            return pointsCell
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 6:
                let btnCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
                if let button = btnCell.viewWithTag(1) as? UIButton {
                    button.setTitle("Edit Basic Information", for: .normal)
                }
                
                return btnCell
                
            default:
                let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
                var textLabel = ""
                var detailLabel = ""
                
                switch indexPath.row {
                case 0:
                    textLabel = "Name"
                    detailLabel = user.name
                    
                case 1:
                    textLabel = "Birthday"
                    detailLabel = user.birthday
                    
                case 2:
                    textLabel = "Gender"
                    detailLabel = user.gender
                    
                case 3:
                    textLabel = "Email"
                    detailLabel = user.emailAddress
                    
                case 4:
                    textLabel = "Mobile Number"
                    detailLabel = user.mobileNumber
                    
                default:
                    textLabel = "Location (City/ Province)"
                    detailLabel = user.location
                }
                
                infoCell.textLabel!.text = textLabel
                infoCell.detailTextLabel!.text = detailLabel
                return infoCell
            }
        }
        
        switch indexPath.row {
        case 3:
            let btnCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
            if let button = btnCell.viewWithTag(1) as? UIButton {
                button.setTitle("Edit Occupation", for: .normal)
            }
            
            return btnCell
            
        default:
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            var textLabel = ""
            var detailLabel = ""
            
            switch indexPath.row {
            case 0:
                textLabel = "Status"
                
            case 1:
                textLabel = "Industry"
                
            default:
                textLabel = "Income Range"
                detailLabel = user.location
            }
            
            infoCell.textLabel!.text = textLabel
            infoCell.detailTextLabel!.text = detailLabel
            return infoCell
        }
        
    }
}

extension UserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 55
        } else if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 6:
                return 60
            default:
                return 44
            }
        }
        
        switch indexPath.row {
        case 3:
            return 60
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 1 else { return 0 }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 1 else { return nil }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50.0))
        headerView.tag = section
        headerView.backgroundColor = UIColor().setColorUsingHex(hex: "005B9C")
        
        let headerLabel = UILabel(frame: CGRect(x: 8.0, y: 0, width: headerView.frame.width - 16.0, height: headerView.frame.height))
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        headerView.addSubview(headerLabel)
        
        var headerLabelText = "Basic Information"
        if section == 3 {
            headerLabelText = "Occupation"
        }
        headerLabel.text = headerLabelText
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.didTapHeader(gestureRecognizer:)))
        headerView.addGestureRecognizer(tapGesture)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
