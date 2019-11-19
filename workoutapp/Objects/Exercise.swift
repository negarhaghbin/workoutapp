//
//  Exercise.swift
//  workoutapp
//
//  Created by Negar on 2019-11-19.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class Exercise: NSObject {
    let title : String
    let gifURL : URL
    let videoURL : URL
    let durationS : Int
    let equipment : String
    
    init(title: String, gifURL: URL, videoURL: URL, durationS: Int, equipment:String) {
        self.title = title
        self.gifURL = gifURL
        self.videoURL = videoURL
        self.durationS = durationS
        self.equipment = equipment
        super.init()
    }

}
