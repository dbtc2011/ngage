//
//  MultipleChoiceTaskViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 06/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import UICircularProgressRing

class MultipleChoiceTaskViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var progressView: UICircularProgressRingView!
    var timeLimit : Timer!
    var maxTime = 30
    var currentTime : Int!
    
    var divider : CGFloat {
        return CGFloat(100/maxTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        button1.layer.cornerRadius = 10
        button2.layer.cornerRadius = 10
        button3.layer.cornerRadius = 10
        button4.layer.cornerRadius = 10
        currentTime = maxTime
        self.labelTimer.text = "\(self.maxTime)"
        button1.setAsDefault()
        button2.setAsDefault()
        button3.setAsDefault()
        button4.setAsDefault()
        scheduleTimer()
    }
    
    func scheduleTimer() {
        timeLimit = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.currentTime == 0 {
                timer.invalidate()
                return
            }
            DispatchQueue.main.async {
//                self.progressView.valueIndicator = ""
                self.currentTime = self.currentTime - 1
                self.labelTimer.text = "\(self.currentTime!)"
                self.progressView.setProgress(value: self.progressView.currentValue! - self.divider, animationDuration: 1)
            }
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func answerButtonClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.button1.setAsWrong()
            self.button2.setAsWrong()
            self.button3.setAsWrong()
            self.button4.setAsCorrect()
        }) { (value) in
            UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                self.button1.setAsDefault()
                self.button2.setAsDefault()
                self.button3.setAsDefault()
                self.button4.setAsDefault()
            }, completion: { (value) in
                
            })
        }
        
    }
    
}
