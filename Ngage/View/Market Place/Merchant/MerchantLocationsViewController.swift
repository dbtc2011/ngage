//
//  MerchantLocationsViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

struct MerchantLocation {
    var id = 0
    var name = ""
    var streetLine1 = ""
    var streetLine2 = ""
    var city = ""
    var contacts = [String]()
}

class MerchantLocationsViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var btnOk: UIButton!
    
    var merchantId = ""
    private var locations = [MerchantLocation]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        fetchMerchantLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Methods
    
    private func setupInterface() {
        viewContainer.layer.cornerRadius = 5.0
        btnOk.layer.cornerRadius = 5.0
    }
    
    private func displayAlert(withMessage message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ngage", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - API
    
    private func fetchMerchantLocations() {
        RegisterService.getMerchantInfo(merchantID: merchantId) { (json, error) in
            guard error == nil else {
                self.displayAlert(withMessage: error!.localizedDescription)
                return
            }
            
            guard json != nil else {
                self.displayAlert(withMessage: "An error has occured")
                return
            }
            
            let resultDict = json!.dictionary
            guard resultDict != nil else {
                self.displayAlert(withMessage: "An error has occured")
                return
            }
            
            if let resultLocations = resultDict!["locations"], let locations = resultLocations.array {
                for location in locations {
                    let locationDict = location.dictionary!
                    var merchantLocation = MerchantLocation()
                    
                    if let id = locationDict["location_id"], let casted = id.int {
                        merchantLocation.id = casted
                    }
                    
                    if let name = locationDict["name"], let casted = name.string {
                        merchantLocation.name = casted
                    }
                    
                    if let streetline1 = locationDict["streetline1"], let casted = streetline1.string {
                        merchantLocation.streetLine1 = casted
                    }
                    
                    if let streetline2 = locationDict["streetline2"], let casted = streetline2.string {
                        merchantLocation.streetLine2 = casted
                    }
                    
                    if let city = locationDict["city"], let casted = city.string {
                        merchantLocation.city = casted
                    }
                    
                    if let contacts = locationDict["contacts"], let casted = contacts.array {
                        for contact in casted {
                            merchantLocation.contacts.append(contact.string!)
                        }
                    }
                    
                    self.locations.append(merchantLocation)
                }
                
                self.tblLocations.reloadData()
            } else {
                self.displayAlert(withMessage: "An error has occured")
            }
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didPressOk(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableView

//MARK: Data Source

extension MerchantLocationsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! MerchantLocationTableViewCell
        let location = locations[indexPath.row]
        
        cell.lblTitle.text = location.name
        cell.lblAddress.text = location.streetLine1 + "\n" + location.streetLine2 + "\n" + location.city
        
        var textContact = ""
        for (index, contact) in location.contacts.enumerated() {
            if index > 0 {
                textContact += "\n"
            }
            
            textContact += contact
        }
        cell.lblContactNumbers.text = textContact
        
        return cell
    }
}

//MARK: Delegate

extension MerchantLocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
