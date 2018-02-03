//
//  DownloadImageClass.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 03/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import Foundation
enum DowloadingImageState {
    
    case new, downloading, done
    
}
class DownloadImageClass: NSObject {
    var imageLink : String = ""
    var tag : Int = 0
    var data: Data?
    var taskIdentifier : Int = 0
    var state = DowloadingImageState.new
    var downloadTask : URLSessionDownloadTask?
    init(link: String) {
        self.imageLink = link
    }
}
