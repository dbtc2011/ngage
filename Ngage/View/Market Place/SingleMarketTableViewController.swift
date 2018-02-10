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
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
        default:
            break
        }
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
    
    //MARK: - IBAction Delegate
    
    @IBAction func didRedeem(_ sender: UIButton) {
        print("Redeem item at index \(sender.tag)")
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
        cell.btnRedeem.tag = indexPath.row
        
        cell.lblSubtitle.text = (market.marketType == .Services) ?
            (redeemable as! ServiceRedeemableModel).artist : ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
