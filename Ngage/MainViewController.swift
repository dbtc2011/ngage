//
//  MainViewController.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import PKHUD

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  func presentDefaultAlertWithMessage(message: String) {
    let alertController = UIAlertController(title: "Ngage PH", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func showSpinner() {
    PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
    if !PKHUD.sharedHUD.isVisible {
      PKHUD.sharedHUD.show()
    }
  }
  
  func showCustomSpinner(with message:String) {
    let imageBG = UIImage(named: "bg_loader")
    PKHUD.sharedHUD.contentView = PKHUDSquareBaseView(image: imageBG, title: "Warning", subtitle: message)
    
    if !PKHUD.sharedHUD.isVisible {
      PKHUD.sharedHUD.show()
    }
  }
  
  func hideSpinner() {
    if PKHUD.sharedHUD.isVisible {
      DispatchQueue.main.async {
        PKHUD.sharedHUD.hide(afterDelay: 0.0) { success in
          // Completion Handler
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  func loaderBG() -> UIView {
    let bgView = UIView()
    let imageBG = UIImage(named: "bg_loader")
    let imageView = UIImageView()
    imageView.image = imageBG
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    bgView.addSubview(imageView)
    return bgView
  }
  
}
