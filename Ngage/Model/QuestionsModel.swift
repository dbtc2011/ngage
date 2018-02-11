//
//  QuestionsModel.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 11/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionsModel: NSObject {
    
    var question : String = ""
    var answer: String = ""
    var choices: [String] = []
    var filePath : String = ""
    
    convenience init(info : JSON) {
        self.init()
        question = info["questionText"].string ?? ""
        answer = info["questionAnswer"].string ?? ""
        if let arrayChoice = info["questionChoices"].array {
            for content in arrayChoice {
                choices.append(content.string ?? "")
            }
        }
        filePath = info["questionFilePath"].string ?? ""
    }
    
    func getCorrectAnswer() -> Int {
        
        let index = choices.index { (value) -> Bool in
            value == self.answer
        }
        return index ?? 0
    }

}
