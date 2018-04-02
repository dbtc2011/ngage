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
    
    var filteredRedeemables: [RedeemableModel]!
    var filteredNonRedeemables: [RedeemableModel]!
    
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
    
    private func presentRedeemVC(withIdentifier identifier: String, withServiceType type: ServicesType?) {
        let storyboard = UIStoryboard(name: "RedeemStoryboard", bundle: Bundle.main)
        let redeemVC = storyboard.instantiateViewController(withIdentifier: identifier) as! RedeemViewController
        redeemVC.delegate = self
        redeemVC.redeemable = selectedRedeemable
        redeemVC.modalPresentationStyle = .overCurrentContext
        redeemVC.modalTransitionStyle = .crossDissolve
        
        if let type = type {
            redeemVC.serviceType = type
        }
        
        self.present(redeemVC, animated: true, completion: nil)
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
            
            self.filterRedeemables() 
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
            
            self.filterRedeemables()
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
            
            self.filterRedeemables()
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
    
    private func filterRedeemables() {
        DispatchQueue.main.async {
            guard self.market.redeemables != nil else {
                self.tableView.reloadData()
                
                return
            }
            
            var userPoints = 0
            if let points = Int(self.user.points) {
                userPoints = points
            }
            
            self.filteredRedeemables = self.market.redeemables.filter ({
                $0.pointsRequired <= userPoints
            })
        
            self.filteredNonRedeemables = self.market.redeemables.filter ({
                $0.pointsRequired > userPoints
            })
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didRedeem(_ sender: UIButton) {
        selectedRedeemable = market.redeemables[sender.tag]
        
        switch market.marketType {
        case .LoadList:
            didRedeemLoadList()
            
        case .Services:
            let serviceMarket = market as! ServiceMarketModel
            var vcIdentifier = "redeemSoundtrack"
            if serviceMarket.type == .Wallpaper {
                vcIdentifier = "redeemWallpaper"
            }
            
            presentRedeemVC(withIdentifier: vcIdentifier, withServiceType: serviceMarket.type)
            
        default:
            break
        }
    }
    
    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard market.redeemables != nil else { return 0 }
        
        var section = 0
        
        if filteredRedeemables.count > 0 {
            section += 1
        }
        
        if filteredNonRedeemables.count > 0 {
            section += 1
        }
        
        return section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard market.redeemables != nil else { return 0 }
        
        if section == 0 && filteredRedeemables.count > 0 {
            return filteredRedeemables.count
        }
        
        return filteredNonRedeemables.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemableCell", for: indexPath) as! RedeemableTableViewCell
        let redeemable = market.redeemables[indexPath.row]
        
        cell.lblTitle.text = redeemable.name
        cell.lblPoint.text = "\(redeemable.pointsRequired)pt"
        if redeemable.pointsRequired > 1 {
            cell.lblPoint.text = cell.lblPoint.text! + "s"
        }
        
        cell.btnRedeem.isHidden = false
        cell.btnRedeem.tag = indexPath.row
        cell.imgArrow.isHidden = true
        
        switch market.marketType {
        case .Services:
            cell.lblSubtitle.text = (redeemable as! ServiceRedeemableModel).artist
            
        case .Merchant:
            let text = NSMutableAttributedString(string: cell.lblTitle.text!,
                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                         NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!])
            let attributedText = NSMutableAttributedString(string: " eGift",
                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor().setColorUsingHex(hex: "31F7ED"),
                                                NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!])
            text.append(attributedText)
            cell.lblTitle.attributedText = text
            
            cell.lblSubtitle.text = (redeemable as! MerchantRedeemableModel).tagline
            cell.btnRedeem.isHidden = true
            cell.imgArrow.isHidden = false
            
        default:
             cell.lblSubtitle.text = ""
        }
        
        if indexPath.section == 0 && filteredRedeemables.count > 0 {
            cell.btnRedeem.isEnabled = true
            cell.btnRedeem.backgroundColor = UIColor().setColorUsingHex(hex: "0066A8")
            cell.viewContent.backgroundColor = UIColor.white
        } else {
            cell.btnRedeem.isEnabled = false
            cell.btnRedeem.backgroundColor = UIColor().setColorUsingHex(hex: "bcbcbc")
            cell.viewContent.backgroundColor = UIColor().setColorUsingHex(hex: "e0e0e0")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard market.marketType == .Merchant else { return }
        
        selectedRedeemable = market.redeemables[indexPath.row]
        presentRedeemVC(withIdentifier: "redeemMerchant", withServiceType: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && filteredRedeemables.count > 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor().setColorUsingHex(hex: "36B1ED")
            
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 20, height: 40))
            label.text = "Rewards available to redeem"
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 14.0)
            headerView.addSubview(label)
            
            return headerView
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor().setColorUsingHex(hex: "36B1ED")
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 20, height: 40))
        label.text = "Collect more points to redeem one of these rewards"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        headerView.addSubview(label)
        
        return headerView
    }
}

//MARK: - RedeemViewController Delegate
extension SingleMarketTableViewController: RedeemViewControllerDelegate {
    func didSuccessfullyRedeem() {
        switch selectedRedeemable {
        case is ServiceRedeemableModel:
            presentRedeemVC(withIdentifier: "redeemSuccessful", withServiceType: nil)
            
        case is MerchantRedeemableModel:
            let storyboard = UIStoryboard(name: "RedeemStoryboard", bundle: Bundle.main)
            let redeemMerchantVC = storyboard.instantiateViewController(withIdentifier: "convertMerchantPoints") as! RedeemMerchantViewController
            redeemMerchantVC.redeemable = selectedRedeemable as! MerchantRedeemableModel
            
            self.navigationController?.pushViewController(redeemMerchantVC, animated: true)
            
        default:
            break
        }
    }
}
