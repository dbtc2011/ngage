//
//  CameraTask.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 11/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import UIKit


extension TaskViewController {
    
    func showPhotoPopOver(){
        let actionSheet = UIAlertController(title: "Camera option", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) in
//                self.checkAuthorizationStatus(.camera)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action) in
            self.showGallery()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            present(actionSheet, animated: true, completion: nil)
        } else {
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 100)
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            present(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.popoverPresentationController?.sourceView = self.view
            imagePicker.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 100)
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
}
extension TaskViewController : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            print("Selected image = \(chosenImage)")
//        }
        // use the image
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TaskViewController : UINavigationControllerDelegate {
    
}
