//
//  MerchantLocationsViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MerchantLocationsViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var btnOk: UIButton!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        return cell
    }
}

//MARK: Delegate

extension MerchantLocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
