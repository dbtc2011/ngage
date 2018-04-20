//
//  HistoryViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistoryViewController: MainViewController {
    
    //MARK: - Properties

    var user = UserModel().mainUser()
    var historyData = [[String: Any]]()
    
    private var dateFormatter = DateFormatter()
    
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
        navigationController?.navigationBar.barTintColor = UIColor(red: 39.0/255.0, green: 120.0/255.0, blue: 206.0/255.0, alpha: 1)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    func getData() {
        showSpinner()
        
        RegisterService.getHistory(fbid: user.facebookId) { (result, error) in
            self.hideSpinner()
            
            if error == nil {
                if let history = result!["history"].array {
                    for content in history {
                        self.historyData.append(content.dictionaryObject!)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.presentDefaultAlertWithMessage(message: error!.localizedDescription)
            }
        }
    }
    
    func convertToAnotherDateFormat(withString strDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let dateOrigFormat = dateFormatter.date(from: strDate) {
            dateFormatter.dateFormat = "MMM dd, yyy - hh:mm a"
            return dateFormatter.string(from: dateOrigFormat)
        }
        
        return ""
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
        
        let cellTitle = cell?.contentView.viewWithTag(1) as! UILabel
        cellTitle.textColor = UIColor.black
        cellTitle.text = history["TrxnType"] as? String ?? ""
        if cellTitle.text == "EARNED    " {
            cellTitle.textColor = UIColor.green
        }else if cellTitle.text == "REDEEM    "{
            cellTitle.textColor = UIColor.red
        }else {
            cellTitle.textColor = UIColor.blue
        }
        
        let points = cell?.contentView.viewWithTag(3) as! UILabel
        points.textColor = UIColor.black
        
        var pointsValue = ""
        if let point = history["Points"] as? Int {
            if point > 1 {
                pointsValue = "\(point) points"
            }else {
                pointsValue = "\(point) point"
            }
        }
        points.text = pointsValue
        
        let name = cell?.contentView.viewWithTag(4) as! UILabel
        name.textColor = UIColor.black
        name.text = history["TITLE"] as? String ?? ""
        
        let date = cell?.contentView.viewWithTag(5) as! UILabel
        date.textColor = UIColor.black
        date.text = ""
        if let dtCreated = history["dtCreated"] as? String {
            date.text = self.convertToAnotherDateFormat(withString: dtCreated)
        }
        
        let image = cell?.contentView.viewWithTag(2) as! UIImageView
        let strLink = history["missionImage"] as? String ?? ""
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
