//
//  RedeemViewController.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 18/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol RedeemViewControllerDelegate {
    func didSuccessfullyRedeem()
}

class RedeemViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnRedeem: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblMerchant: UILabel!
    
    @IBOutlet weak var imgWallpaper: UIImageView!
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewTrack: UIView!
    
    var redeemable: RedeemableModel!
    var serviceType: ServicesType!
    
    var delegate: RedeemViewControllerDelegate!
    
    var player: AVPlayer?
    
    var audioTimer: Timer?
    var audioDuration = 0.0
    var audioInterval = 0.0
    
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
        viewCenter.layer.cornerRadius = 5.0
        
        if activityIndicator != nil {
            activityIndicator.startAnimating()
        }
        
        if btnRedeem != nil {
            btnRedeem.layer.cornerRadius = 5.0
            btnRedeem.isEnabled = false
        }
        
        if lblPoints != nil {
            btnClose.layer.cornerRadius = 5.0
            
            var textToReplace = "\(redeemable.pointsRequired)pt"
            if redeemable.pointsRequired > 1 {
                textToReplace += "s"
            }
            
            let text = lblPoints.text?.replacingOccurrences(of: "<pt>", with: textToReplace)
            lblPoints.text = text
            
            return
        }
        
        if btnClose != nil {
            btnClose.layer.cornerRadius = btnClose.frame.width/2
        }
        
        if btnSend != nil {
            btnSend.layer.cornerRadius = 5.0
        }
        
        if viewTrack != nil {
            viewTrack.layer.cornerRadius = viewTrack.frame.width/2
        }
        
        switch redeemable {
        case is ServiceRedeemableModel:
            let serviceRedeemable = redeemable as! ServiceRedeemableModel
            lblTitle.text = serviceRedeemable.name
            lblDescription.text = serviceRedeemable.artist
            
            showPreview(forRedeemable: serviceRedeemable)
            
        case is MerchantRedeemableModel:
            lblMerchant.text = lblMerchant.text?.replacingOccurrences(of: "<merchant>", with: redeemable.name)
            btnRedeem.isEnabled = true
            
        default:
            break
        }
    }
    
    private func showPreview(forRedeemable redeemable: ServiceRedeemableModel) {
        switch serviceType {
        case .Wallpaper:
            downloadImage(with: redeemable.optimizedPic, completionHandler: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.imgWallpaper.image = image
                        self.btnRedeem.isEnabled = true
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        case .Ringtone:
            var fileURL = redeemable.filePath.replacingOccurrences(of: "http", with: "https")
            fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: fileURL) {
                self.activityIndicator.stopAnimating()
                self.btnRedeem.isEnabled = true
                
                let asset = AVURLAsset(url: url)
                audioDuration = CMTimeGetSeconds(asset.duration)
                audioInterval = Double(viewLine.frame.width)/audioDuration
                self.enableTimer()
                
                self.player = AVPlayer(url: url)
                self.player!.play()
            }
        default:
            break
        }
    }
    
    private func downloadImage(with urlString: String,
                                      completionHandler: @escaping (_ image: UIImage?) -> Void) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Redeem error", message: error!.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(ac, animated: true)
                }
                
                completionHandler(nil)
            }
            
            if let data = data, let image = UIImage(data: data) {
                completionHandler(image)
            }
        }).resume()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Redeem error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else {
            self.delegate.didSuccessfullyRedeem()
        }
    }
    
    //MARK: - Timer
    
    private func enableTimer() {
        disableTimer()
        
        audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }
    
    private func disableTimer() {
        guard audioTimer != nil else { return }
        
        audioTimer!.invalidate()
        audioTimer = nil
    }
    
    @objc func timerDidFire() {
        audioDuration -= 1
        
        viewTrack.frame.origin.x += CGFloat(audioInterval)
        
        if audioDuration <= 0 {
            disableTimer()
        } else if viewTrack.frame.maxX >= viewLine.frame.maxX {
            disableTimer()
        }
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didRedeem(_ sender: UIButton) {
        sender.isEnabled = false
        activityIndicator?.startAnimating()
        
        if let serviceRedeemable = redeemable as? ServiceRedeemableModel {
            switch serviceType {
            case .Wallpaper:
                downloadImage(with: serviceRedeemable.filePath, completionHandler: { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            case .Ringtone:
                let fileComponents = serviceRedeemable.filePath.components(separatedBy: "/")
                
                var fileURL = serviceRedeemable.filePath.replacingOccurrences(of: "http", with: "https")
                fileURL = fileURL.replacingOccurrences(of: " ", with: "%20")
                if let url = URL(string: fileURL), let data = NSData(contentsOf: url) {
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(fileComponents.last!)
                    print(fileURL)
                    
                    let success = data.write(to: fileURL, atomically: true)
                    if success {
                        DispatchQueue.main.async {
                            if self.player != nil {
                                self.player!.pause()
                            }
                            
                            self.activityIndicator.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                            
                            self.delegate.didSuccessfullyRedeem()
                        }
                        
                        return
                    }
                }
                
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Redeem error", message: "There was a problem redeeming this item. Please try again later.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(ac, animated: true)
                    
                    if self.player != nil {
                        self.player!.pause()
                    }
                    
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
                
            default:
                break
            }
        } else if let _ = redeemable as? MerchantRedeemableModel  {
            self.dismiss(animated: true, completion: nil)
            
            self.delegate.didSuccessfullyRedeem()
        }
        
        
    }
    
    @IBAction func didClose(_ sender: UIButton) {
        if player != nil {
            player!.pause()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
