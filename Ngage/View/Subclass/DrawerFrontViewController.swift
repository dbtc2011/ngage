//
//  DrawerFrontViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerFrontViewController: MainViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let drawer = self.navigationController?.parent as? KYDrawerController {
            drawer.screenEdgePanGestureEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let drawer = self.navigationController?.parent as? KYDrawerController {
            drawer.screenEdgePanGestureEnabled = false
        }
    }
    
    //MARK: - User Interactions
    @IBAction func toggleDrawer(_ sender: Any) {
        if let drawer = self.navigationController?.parent as? KYDrawerController {
            let newState: KYDrawerController.DrawerState = drawer.drawerState == .closed ? .opened : .closed
            drawer.setDrawerState(newState, animated: true)
        }
    }
}

