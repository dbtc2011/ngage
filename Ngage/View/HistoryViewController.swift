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
    
    //MARK: - Properties

    var user = UserModel().mainUser()
    var historyData = [[String: String]]()
    
    private var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        getData()
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
    
    //MARK: - Methods
    
    func getData() {
        RegisterService.getHistory(fbid: user.facebookId) { (result, error) in
            if error == nil {
                if let history = result!["history"].array {
                    for content in history {
                        let historyContent = ["title": content["TITLE"].string ?? "",
                                              "image": content["missionImage"].string ?? ""]
                        self.historyData.append(historyContent)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                print(error!.localizedDescription)
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
}

//MARK: - UITableView

//MARK: Data Source

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
        
        let image = cell?.contentView.viewWithTag(2) as! UIImageView
        let strLink = history["image"] ?? ""
        if let link = URL(string: strLink) {
            if (self.cache.object(forKey: link as AnyObject) != nil) {
                // Use cache
                image.image = self.cache.object(forKey: link as AnyObject) as? UIImage
            } else {
                //Download
                URLSession.shared.dataTask( with: link, completionHandler: {
                    (data, response, error) -> Void in
                    DispatchQueue.main.async {
                        image.contentMode =  .scaleAspectFit
                        if let data = data {
                            image.image = UIImage(data: data)
                            self.cache.setObject(image.image!, forKey: link as AnyObject)
                        }
                    }
                }).resume()
            }
        }
        
        if indexPath.row % 2 == 0 {
            cell?.contentView.backgroundColor = UIColor.white
        } else {
            cell?.contentView.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        }
        
        return cell!
    }
}

//MARK: Delegate

extension HistoryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
