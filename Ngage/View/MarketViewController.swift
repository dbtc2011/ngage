//
//  MarketViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    var markets : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        temporaryTitle()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func temporaryTitle() {
        markets = ["SMART", "GLOBE", "SUN", "MOBILE LEGENDS", "ZED", "ZALORA"]
        collectionView.reloadData()

    }
    
    //MARK: - Button Action
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
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

extension MarketViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketTitleCell", for: indexPath) as! MarketButtonCollectionViewCell
        cell.setupContent(title: markets[indexPath.row])
        return cell
        
    }
}

extension MarketViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelWidth = markets[indexPath.row].width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 13))
        return CGSize(width: labelWidth + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension MarketViewController : UICollectionViewDelegate {
    
}
