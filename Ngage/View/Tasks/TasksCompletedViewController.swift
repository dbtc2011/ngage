//
//  TasksCompletedViewController.swift
//  Ngage PH
//
//  Created by Mark Angeles on 01/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol TasksCompletedViewControllerDelegate {
    func didCloseCompletedController()
}

class TasksCompletedViewController: UIViewController {

    @IBOutlet weak var buttonOk: UIButton!
    var delegate: TasksCompletedViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        view.isOpaque = false
        view.backgroundColor = UIColor.clear
        buttonOk.layer.cornerRadius = 27
        buttonOk.backgroundColor = UIColor(red: 122.0/255.0, green: 190.0/255.0, blue: 86.0/255.0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapOKButton(_ sender: UIButton) {
        
        delegate?.didCloseCompletedController()
        dismiss(animated: false) {
            
        }
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
