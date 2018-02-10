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
    
    private let marketTitles = ["RINGING TONE", "eCARD", "SMART", "GLOBE", "SUN", "MOBILE LEGENDS"]
    private var markets = [MarketModel]()
    private var selectedMarket: MarketModel!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializePageViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func initializePageViewController() {
        for (index, title) in marketTitles.enumerated() {
            var marketModel: MarketModel!
            
            switch index {
            case 0, 1:
                let serviceModel = ServiceMarketModel()
                serviceModel.type = .Ringtone
                serviceModel.type = (index == 0) ? .Ringtone : .Wallpaper
                
                marketModel = serviceModel
                marketModel.marketType = .Services
                
            default:
                let loadListModel = LoadListMarketModel()
                loadListModel.type = .Smart
                if index == 3 {
                    loadListModel.type = .Globe
                } else if index == 4 {
                    loadListModel.type = .Sun
                } else if index == 5 {
                    loadListModel.type = .MobileLegends
                }
                
                marketModel = loadListModel
                marketModel.marketType = .LoadList
            }
            
            marketModel.marketId = index
            marketModel.name = title
            markets.append(marketModel)
        }
        
        selectedMarket = markets.first!
        
        collectionView.reloadData()
        
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
