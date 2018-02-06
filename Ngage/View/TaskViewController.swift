//
//  TaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum TaskAppCode : Int {
    case updateProfile = 1
}

class TaskViewController: UIViewController {

    var mission: MissionModel!
    var user = UserModel().mainUser()
    var accomplishmentView:  AccomplishmentView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let color = UIColor().setColorUsingHex(hex: mission.colorBackground)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        let accFrame = CGRect(x: (UIScreen.main.bounds.width/2)-(150/2), y: 55, width: 150, height: 150)
        accomplishmentView = AccomplishmentView(frame: accFrame)
        accomplishmentView.setMainColor(color: UIColor().setColorUsingHex(hex: mission.colorPrimary))
        accomplishmentView.setPercentage(percent: 60)
        accomplishmentView.backgroundColor = UIColor.clear
        view.addSubview(accomplishmentView)
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let task = sender as! TaskModel
        if let controller = segue.destination as? WebViewTaskViewController {
            var url = ""
            switch task.type {
            case 1:
                url = "http://ph.ngage.ph/web/Home/profile?MID={MID}&TID={TID}&TTyID={TTyID}&FBID={FBID}&DID={DID}"
                url = url.replacingOccurrences(of: "{MID}", with: "\(mission.code)")
                url = url.replacingOccurrences(of: "{TID}", with: "\(task.code)")
                url = url.replacingOccurrences(of: "{TTyID}", with: "\(task.type)")
                url = url.replacingOccurrences(of: "{FBID}", with: "\(user.facebookId)")
                url = url.replacingOccurrences(of: "{DID}", with: "\(user.deviceID)")
                break
            default:
                break
            }
            controller.task = task
            controller.mission = mission
            controller.webLink = url
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension TaskViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = mission.tasks[indexPath.row]
        
        switch task.type {
        case 1:
            self.performSegue(withIdentifier: "webViewTask", sender: task)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}

extension TaskViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mission.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        let color = UIColor().setColorUsingHex(hex: mission.colorBackground)
        cell.setupUsing(task: mission.tasks[indexPath.row], color: color)
        return cell
    }
}

