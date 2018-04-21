//
//  NotificationViewController.swift
//  Ngage PH
//
//  Created by Mark Angeles on 03/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

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
        CoreDataManager.sharedInstance.fetchSavedObjects(forEntity: .Notification) { (result, notifications) in
            if result == .Success {
                self.notifications = notifications as! [NotificationModel]
            }
            
            self.tblNotifications.reloadData()
            
            if self.notifications.count == 0 {
                self.imgNoData.isHidden = false
            }
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
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotificationDetailsTableViewController,
            let indexPath = sender as? IndexPath {
            vc.notification = notifications[indexPath.row]
        }
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
        
        performSegue(withIdentifier: "didSelectNotification", sender: indexPath)
    }
}
