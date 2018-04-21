//
//  NotificationViewController.swift
//  Ngage PH
//
//  Created by Mark Angeles on 03/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum NotifcationType: String {
    case UP = "UP", //Blast All - New Version with Button Update
         I = "I", //Blast All - with Invite Button
         Default
}

struct NotificationModel {
    var id: NotifcationType!
    var title = ""
    var message = ""
    var date = ""
}

class NotificationViewController: MainViewController {

    //MARK: - Properties
    
    @IBOutlet weak var tblNotifications: UITableView!
    @IBOutlet weak var imgNoData: UIImageView!
    
    private var notifications = [NotificationModel]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 39.0/255.0, green: 120.0/255.0, blue: 206.0/255.0, alpha: 1)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupMockData() {
        let notificationUpdate = NotificationModel(id: .UP, title: "Update Available",
                                                  message: "We will be giving 10 points for each referral so go and tell your friends about Ngage! Thank you!", date: "31/1/2018")
        let notificationInvite = NotificationModel(id: .I, title: "Invite",
                                                  message: "Earn more points by inviting your friends to install Ngage and make sure to give them your referral code.", date: "21/4/2018")
        let notificationDefault = NotificationModel(id: .Default, title: "Announcement",
                                                  message: "This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement. This is just a test default announcement.", date: "01/05/2018")
        notifications = [notificationUpdate, notificationInvite, notificationDefault]
        
        tblNotifications.reloadData()
        
        if notifications.count == 0 {
            imgNoData.isHidden = false
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}

extension NotificationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        let notification = notifications[indexPath.row]
        notificationCell.setupCell(withNotificationModel: notification)
        
        return notificationCell
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
