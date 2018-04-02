//
//  MarketPageViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 06/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MarketPageViewController: UIPageViewController {

    //MARK: - Properties
    
    //MARK: Public
    
    var selectedHeaderIndex = 0
    var markets: [MarketModel]!
    
    //MARK: Private
    
    private var previousSelectedIndex = 0
    private var orderedViewControllers = [UIViewController]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor().setColorUsingHex(hex: "F6F6F8")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    func initPageViewControllers(withNumberOfControllers number: Int) {
        for market in markets {
            if let singleMarketVC = self.storyboard?.instantiateViewController(withIdentifier: "singleMarketTVC") as? SingleMarketTableViewController {
                singleMarketVC.market = market
                orderedViewControllers.append(singleMarketVC)
            }
        }
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func updateSelectedPageViewController() {
        var direction = UIPageViewControllerNavigationDirection.reverse
        if previousSelectedIndex < selectedHeaderIndex {
            direction = .forward
        }
        
        setViewControllers([orderedViewControllers[selectedHeaderIndex]],
                           direction: direction,
                           animated: true,
                           completion: nil)
        
        previousSelectedIndex = selectedHeaderIndex
    }
}

extension MarketPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}

extension MarketPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first else { return }
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return }
        if let marketVC = self.parent as? MarketViewController {
            selectedHeaderIndex = viewControllerIndex
            print(selectedHeaderIndex)
            marketVC.selectHeader(atIndex: selectedHeaderIndex)
        }
    }
}
