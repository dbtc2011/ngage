//
//  HistoryViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistoryViewController: UIViewController {

    var user = UserModel().mainUser()
    var historyData = [[String: String]]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        getData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    func getData() {
        RegisterService.getHistory(fbid: user.facebookId) { (result, error) in
            if error == nil {
                if let history = result!["history"].array {
                    for content in history {
                        let historyContent = ["title": content["TITLE"].string ?? ""]
                        self.historyData.append(historyContent)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else {
                print(error?.localizedDescription)
            }
        }
    }
    //MARK: - Button Actions
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history = historyData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")
        let name = cell?.contentView.viewWithTag(1) as! UILabel
        name.textColor = UIColor.black
        name.text = history["title"] ?? ""
        
        if indexPath.row % 2 == 0 {
            cell?.contentView.backgroundColor = UIColor.white
        }else {
            cell?.contentView.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        }
        
//        let number = cell?.contentView.viewWithTag(2) as! UIImageView
//        number.text = contactDict["number"]
//
        return cell!
    }
}
extension HistoryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
