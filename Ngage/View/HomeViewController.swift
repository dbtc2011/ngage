//
//  HomeViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class HomeViewController: DrawerFrontViewController {
    
    let fbid = "10211232954239118"
    let userID = "5369"
    @IBOutlet weak var buttonDrawer: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getMission()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIColor(color: UIColor.red)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //taskPage
    //MARK: - Function
    func setupUI() {
        buttonDrawer.addTarget(self, action: #selector(toggleDrawer(_:)), for: UIControlEvents.touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(toggleDrawer(_:)))
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    func setUIColor(color : UIColor) {
        self.view.backgroundColor = color
        self.collectionView.backgroundColor = color
        Util.setNavigationBar(color: color)
        navigationController?.navigationBar.barTintColor = color

    }
    
    func getMission() {
        
        RegisterService.getMissionList(fbid: fbid) { (result, error) in
            print(result)
            print(error)
        }
        
        
    }
    
    //MARK: - Button action

    @IBAction func drawerClicked(_ sender: UIBarButtonItem) {
        
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

extension HomeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionCell", for: indexPath) as! HomeCollectionViewCell
        cell.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.setupContents(color: UIColor.red)
        case 1:
            cell.setupContents(color: UIColor.blue)
        case 2:
            cell.setupContents(color: UIColor.gray)
        case 3:
            cell.setupContents(color: UIColor.yellow)
        case 4:
            cell.setupContents(color: UIColor.green)
        default:
            break;
        }
        
        return cell
        
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height-50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension HomeViewController : UICollectionViewDelegate {
    
}

extension HomeViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll view = \(scrollView.contentOffset)")
        
        let index = scrollView.contentOffset.x/self.view.frame.size.width
        print(index)
        switch Int(index) {
        case 0:
            self.setUIColor(color: UIColor.red)
        case 1:
            self.setUIColor(color: UIColor.blue)
        case 2:
            self.setUIColor(color: UIColor.gray)
        case 3:
            self.setUIColor(color: UIColor.yellow)
        case 4:
            self.setUIColor(color: UIColor.green)
        default:
            break;
        }
    }
}
extension HomeViewController : HomeCollectionViewCellDelegate {
    func homeDidTapStart() {
        self.performSegue(withIdentifier: "taskPage", sender: self)
    }
}
