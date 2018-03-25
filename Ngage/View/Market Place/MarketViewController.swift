//
//  MarketViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    
    private let marketTitles = ["RINGING TONE", "eCARD", "SMART", "GLOBE", "SUN",
                                "MOBILE LEGENDS", "FOOD", "SHOP", "HEALTH & WELLNESS",
                                "TRAVEL & LEISURE", "SERVICES"]
    private var markets = [MarketModel]()
    private var selectedMarket: MarketModel!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        
        initializeMarkets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: self.navigationController!.navigationBar.frame.height))
        titleLabel.text = "Market Place"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        titleLabel.textColor = UIColor.white
        
        self.navigationItem.titleView = titleLabel
        self.navigationController!.navigationBar.barTintColor = UIColor().setColorUsingHex(hex: "015C9B")
    }
    
    private func initializeMarkets() {
        let servicesTypes: [ServicesType] = [.Ringtone, .Wallpaper]
        let loadListTypes: [LoadListType] = [.Smart, .Globe, .Sun, .MobileLegends]
        let merchantTypes: [MerchantType] = [.Food, .Shop, .Health, .Travel, .Service]
        
        for (index, title) in marketTitles.enumerated() {
            var marketModel: MarketModel!
            
            switch index {
            case 0, 1:
                let serviceModel = ServiceMarketModel()
                serviceModel.type = servicesTypes[index]
                
                marketModel = serviceModel
                marketModel.marketType = .Services
                
            case 2, 3, 4, 5:
                let loadListModel = LoadListMarketModel()
                loadListModel.type = loadListTypes[index - 2]
                
                marketModel = loadListModel
                marketModel.marketType = .LoadList
                
            default:
                let merchantModel = MerchantMarketModel()
                merchantModel.type = merchantTypes[index - 6]
                
                marketModel = merchantModel
                marketModel.marketType = .Merchant
            }
            
            marketModel.marketId = index
            marketModel.name = title
            markets.append(marketModel)
        }
        
        selectedMarket = markets.first!
        
        collectionView.reloadData()
        initializePageViewController()
    }
    
    private func initializePageViewController() {
        if let marketPageVC = self.childViewControllers.first as? MarketPageViewController {
            marketPageVC.markets = markets
            marketPageVC.initPageViewControllers(withNumberOfControllers: markets.count)
            
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}

//MARK: - UICollectionView

//MARK: Data Source

extension MarketViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketTitleCell", for: indexPath) as! MarketButtonCollectionViewCell
        
        let market = markets[indexPath.row]
        cell.setupContent(withTitle: market.name)
        
        cell.setSelectionIndicator(isHidden: !{ selectedMarket == market }())
        
        return cell
    }
}

//MARK: Flow Layout

extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = markets[indexPath.row].name
        let labelWidth = title.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 13))
        return CGSize(width: labelWidth + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: Delegate

extension MarketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //update page view controller
        if let marketPageVC = self.childViewControllers.first as? MarketPageViewController {
            marketPageVC.selectedHeaderIndex = indexPath.row
            marketPageVC.updateSelectedPageViewController()
        }
        
        //update and animate collection view
        selectedMarket = markets[indexPath.row]
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        
        let index = indexPath.row
        guard index < markets.count - 1 else { return }
        
        let indexPath = IndexPath(row: index + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
