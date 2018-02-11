//
//  SingleMarketTableViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 06/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class SingleMarketTableViewController: UITableViewController {

    //MARK: - Properties
    
    var market: MarketModel!
    var selectedRedeemable: RedeemableModel!
    
    var user: UserModel!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = UserModel().mainUser()
        initializeMarketRedeemables()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func initializeMarketRedeemables() {
        guard market.redeemables == nil else { return }
        
        switch market.marketType {
        case .Services:
            fetchServiceMarketRedeemables()
            
        case .LoadList:
            fetchLoadListMarketRedeemables()
            
        case .Merchant:
            fetchMerchantMarketRedeemables()
            
        default:
            break
        }
    }
    
    private func addDoneButtonKeyboardAccessory(forTextfield textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        textField.inputAccessoryView = keyboardToolbar
    }
    
    private func didRedeemLoadList() {
        let alert = UIAlertController(title: "Ngage", message: "Input mobile number", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "639xxxxxxxxx"
            textField.keyboardType = .numberPad
            self.addDoneButtonKeyboardAccessory(forTextfield: textField)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let redeemAction = UIAlertAction(title: "Redeem", style: .default) { (action) in
            let textField = alert.textFields![0]
            self.redeemLoadListMarketRedeemable(withMobileNumber: textField.text!)
        }
        alert.addAction(redeemAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - API
    
    private func fetchServiceMarketRedeemables() {
        let serviceMarket = market as! ServiceMarketModel
        RegisterService.getServicesType(serviceType: serviceMarket.type.rawValue) { (json, error) in
            guard error == nil else {
                print(error!.description)
                return
            }
            
            guard json != nil else { return }
            
            let services = json!["Services"].array
            guard services != nil else { return }
            
            self.market.redeemables = [RedeemableModel]()
            
            for service in services! {
                if let serviceDict = service.dictionary {
                    let redeemable = ServiceRedeemableModel()
                    
                    if let id = serviceDict["ID"], let casted = id.int {
                        redeemable.id = casted
                    }
                    
                    if let name = serviceDict["Name"], let casted = name.string {
                        redeemable.name = casted
                    }
                    
                    if let path = serviceDict["FilePath"], let casted = path.string {
                        redeemable.filePath = casted
                    }
                    
                    if let optimized = serviceDict["OptimizedPic"], let casted = optimized.string {
                        redeemable.optimizedPic = casted
                    }
                    
                    if let points = serviceDict["Points"], let casted = points.int {
                        redeemable.pointsRequired = casted
                    }
                    
                    if let artist = serviceDict["Artist"], let casted = artist.string {
                        redeemable.artist = casted
                    }
                    
                    self.market.redeemables.append(redeemable)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchLoadListMarketRedeemables() {
        let loadListMarket = market as! LoadListMarketModel
        RegisterService.getLoadList(telco: loadListMarket.type.rawValue) { (json, error) in
            guard error == nil else {
                print(error!.description)
                return
            }
            
            guard json != nil else { return }
            
            let loadList = json!["LoadList"].array
            guard loadList != nil else { return }
            
            self.market.redeemables = [RedeemableModel]()
            
            for load in loadList! {
                if let loadListDict = load.dictionary {
                    let redeemable = LoadListRedeemableModel()
                    
                    if let id = loadListDict["ID"], let casted = id.int {
                        redeemable.id = casted
                    }
                    
                    if let name = loadListDict["ProductName"], let casted = name.string {
                        redeemable.name = casted
                    }
                    
                    if let points = loadListDict["Reward"], let casted = points.int {
                        redeemable.pointsRequired = casted
                    }
                    
                    if let code = loadListDict["ProductCode"], let casted = code.string {
                        redeemable.code = casted
                    }
                    
                    if let description = loadListDict["Description"], let casted = description.string {
                        redeemable.loadDescription = casted
                    }
                    
                    self.market.redeemables.append(redeemable)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchMerchantMarketRedeemables() {
        let merchantMarket = market as! MerchantMarketModel
        RegisterService.getMerchantList(category: merchantMarket.type.rawValue) { (json, error) in
            guard error == nil else {
                print(error!.description)
                return
            }
            
            guard json != nil else { return }
            
            let merchants = json!["merchantdetails"].array
            guard merchants != nil else { return }
            
            self.market.redeemables = [RedeemableModel]()
            
            for merchant in merchants! {
                if let merchantDict = merchant.dictionary {
                    let redeemable = MerchantRedeemableModel()
                    
                    if let id = merchantDict["merchant_id"], let casted = id.string {
                        if let intCasted = Int(casted) {
                            redeemable.id = intCasted
                        }
                    }
                    
                    if let name = merchantDict["name"], let casted = name.string {
                        redeemable.name = casted
                    }
                    
                    if let isVirtual = merchantDict["is_virtual"], let casted = isVirtual.string {
                        redeemable.isVirtual = casted
                    }
                    
                    if let details = merchantDict["details_url"], let casted = details.string {
                        redeemable.detailsUrl = casted
                    }
                    
                    if let logo = merchantDict["logo_url"], let casted = logo.string {
                        redeemable.logoUrl = casted
                    }
                    
                    if let tagline = merchantDict["tagline"], let casted = tagline.string {
                        redeemable.tagline = casted
                    }
                    
                    if let subcategory = merchantDict["subcategory"], let casted = subcategory.string {
                        redeemable.subcategory = casted
                    }
                    
                    if let locationCount = merchantDict["location_count"], let casted = locationCount.string {
                        if let intCasted = Int(casted) {
                            redeemable.locationCount = intCasted
                        }
                    }
                    
                    if let denominationCount = merchantDict["denomination_count"], let casted = denominationCount.string {
                        if let intCasted = Int(casted) {
                            redeemable.denominationCount = intCasted
                        }
                    }
                    
                    if let hasCustom = merchantDict["has_custom"], let casted = hasCustom.string {
                        redeemable.hasCustom = casted
                    }
                    
                    if let hasMarkup = merchantDict["has_markup"], let casted = hasMarkup.string {
                        redeemable.hasMarkup = casted
                    }
                    
                    if let points = merchantDict["minimum_custom_value"], let casted = points.string {
                        if let intCasted = Int(casted) {
                            redeemable.pointsRequired = intCasted
                        }
                    }
                    
                    if let pointsMaximum = merchantDict["maximum_custom_value"], let casted = pointsMaximum.string {
                        if let intCasted = Int(casted) {
                            redeemable.maximumPointsRequired = intCasted
                        }
                    }
                    
                    self.market.redeemables.append(redeemable)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func redeemLoadListMarketRedeemable(withMobileNumber mobileNumber: String) {
        let loadListRedeemable = selectedRedeemable as! LoadListRedeemableModel
        let userPoints = (Int(user.points) != nil) ? Int(user.points)! : 0
        let currentPoints = userPoints - loadListRedeemable.pointsRequired
        
        RegisterService.sendLoadCentral(to: mobileNumber, pcode: loadListRedeemable.code, fbid: user.facebookId, prevPoints: user.points, currentPoint: "\(currentPoints)", points: "\(loadListRedeemable.pointsRequired)") { (json, error) in
            guard error == nil else {
                print(error!.description)
                return
            }
            
            guard json != nil else { return }
            
            let resultDict = json!.dictionary
            guard resultDict != nil else { return }
            
            if let points = resultDict!["Points"], let casted = points.string {
                CoreDataManager.sharedInstance.updateUserPoints(withPoints: casted, completionHandler: { (result) in
                    if result == .Error {
                        print(CoreDataManager.sharedInstance.errorDescription)
                    }
                })
            }
            
            if let statusCode = resultDict!["statusCode"], let castedStatusCode = statusCode.int {
                var alertMessage = "Successfully redeemed item"
                if castedStatusCode != 200 {
                    if let status = resultDict!["status"], let castedStatus = status.string {
                        alertMessage = castedStatus
                    }
                }
                
                let alert = UIAlertController(title: "Ngage", message: alertMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didRedeem(_ sender: UIButton) {
        selectedRedeemable = market.redeemables[sender.tag]
        
        switch market.marketType {
        case .LoadList:
            didRedeemLoadList()
            
        default:
            break
        }
    }
    
    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard market.redeemables != nil else { return 0 }
        
        return market.redeemables.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemableCell", for: indexPath) as! RedeemableTableViewCell
        let redeemable = market.redeemables[indexPath.row]
        
        cell.lblTitle.text = redeemable.name
        cell.lblPoint.text = "\(redeemable.pointsRequired)"
        
        cell.btnRedeem.isHidden = false
        cell.btnRedeem.tag = indexPath.row
        
        switch market.marketType {
        case .Services:
            cell.lblSubtitle.text = (redeemable as! ServiceRedeemableModel).artist
            
        case .Merchant:
            cell.lblSubtitle.text = (redeemable as! MerchantRedeemableModel).tagline
            cell.btnRedeem.isHidden = true
            
        default:
             cell.lblSubtitle.text = ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard market.marketType == .Merchant else { return }
        
        print("Redeem item at index \(indexPath.row)")
    }
}
