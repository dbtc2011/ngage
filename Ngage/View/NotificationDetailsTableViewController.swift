//
//  NotificationDetailsTableViewController.swift
//  Ngage PH
//
//  Created by cybilltek on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class NotificationDetailsTableViewController: UITableViewController {

    //MARK: - Properties
    
    var notification = NotificationModel()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didPressBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notification.notificationType == "UP" ||
           notification.notificationType == "I" {
            return 3
        }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! NotificationDetailHeaderTableViewCell
            headerCell.setDate(withDate: notification.date)
            
            return headerCell
            
        case 1:
            let messageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! NotificationDetailMessageTableViewCell
            messageCell.setContent(withNotificationModel: notification)
            
            return messageCell
            
        default:
            var identifier = "updateCell"
            if notification.notificationType == "I" {
                identifier = "inviteCell"
            }
            
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NotificationDetailButtonTableViewCell
            buttonCell.delegate = self
            
            return buttonCell
        }
    }
}

extension NotificationDetailsTableViewController: NotificationDetailButtonTableViewCellDelegate {
    func didClickInviteFriends() {
        
    }
    
    func didClickUpdateApplication() {
        
    }
}
