//
//  ContactListViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 17/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import Contacts
import Messages
import MessageUI

class ContactListViewController: UIViewController {

    var user = UserModel().mainUser()
    var task : TaskModel!
    var mission : MissionModel!
    @IBOutlet weak var labelInstructions: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var contentMessage = ""
    var contacts = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setup
    func setupUI() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            NSLog(">>>> Contact list:")
            for contact in cnContacts {
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                
                var number = (contact.phoneNumbers.first?.value)?.stringValue ?? ""
                print(contact)
                number = number.replacingOccurrences(of: "+63", with: "0")
                number = number.replacingOccurrences(of: " ", with: "")
                number = number.replacingOccurrences(of: "(", with: "")
                number = number.replacingOccurrences(of: ")", with: "")
                
                var contactDict = ["name" : fullName,
                                   "number" : number,
                                   "selected": "no"]
                self.contacts.append(contactDict)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getData() {
        RegisterService.getTaskContent(missionID: "\(mission.code)", taskID: "\(task.code)", tasktype: "\(task.type)", contentID: task.contentId, FBID: user.facebookId) { (result, error) in
            if let result = result {
                if let contents = result["content"].array {
                    let content = contents[0].dictionary
                    print("Content = \(contents)")
                    if let titleContent = content!["ContentTitle"]?.string {
                        self.labelInstructions.text = titleContent
                    }
                    
                    if let ContentData = content!["ContentData"]?.string {
                        self.contentMessage = ContentData
                    }
                }
            }
        }
    }
    
    @IBAction func sendButtonClicked(_ sender: UIBarButtonItem) {
        if MFMessageComposeViewController.canSendText() {
            var recipients = [String]()
            for content in contacts {
                if content["selected"] == "yes" {
                    recipients.append(content["number"]!)
                }
            }
            print("SMS services are not available")
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = recipients
            contentMessage = contentMessage.replacingOccurrences(of: "{NAME}", with: user.name)
            composeVC.body = contentMessage
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                present(composeVC, animated: true, completion: nil)
            } else {
                composeVC.popoverPresentationController?.sourceView = self.view
                composeVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 100)
                present(composeVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
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

extension ContactListViewController : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
}

extension ContactListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contactDict = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")
        let name = cell?.contentView.viewWithTag(1) as! UILabel
        name.text = contactDict["name"]
    
        let number = cell?.contentView.viewWithTag(2) as! UILabel
        number.text = contactDict["number"]
        if contactDict["selected"] == "no" {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }else {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell!
    }
}

extension ContactListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var contactDict = contacts[indexPath.row]
        if contactDict["selected"] == "yes" {
            contactDict["selected"] = "no"
        }else {
            contactDict["selected"] = "yes"
        }
        contacts[indexPath.row] = contactDict
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        
    }
}
