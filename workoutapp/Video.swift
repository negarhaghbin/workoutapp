//
//  Video.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class Video: NSObject {
    let url: URL
    let thumbURL: URL
    let title: String
    let subtitle: String

    init(url: URL, thumbURL: URL, title: String, subtitle: String) {
      self.url = url
      self.thumbURL = thumbURL
      self.title = title
      self.subtitle = subtitle
      super.init()
    }
    
    class func localVideos() -> [Video] {
      var videos: [Video] = []
      let names = [ "alternatingLunges", "armCircles", "doubleChopKneePulls", "InnerTightLift", "stepsAndPulls"]
      let titles = [ "Alternating Lunges", "Arm Circles", "Double Chop Knee Pulls", "Inner Thight Lift",  "Lateral Steps And Pulls" ]
      let subtitles = ["Duration: 25 seconds \nBody Focus: Lower body \nEquipment: No Equipment", "Duration: 60 seconds (30 seconds each direction) \nBody Focus: Upper body \nEquipment: No Equipment",
                       "Duration: 50 seconds (30 seconds each direction) \nBody Focus: Abs \nEquipment: No Equipment",
                       "Duration: 80 seconds (40 seconds each side) \nBody Focus: lower body \nEquipment: No Equipment",
                       "Duration: 30 seconds \nBody Focus: Total body \nEquipment: No Equipment"]
      
      for (index, name) in names.enumerated() {
        guard let urlPath = Bundle.main.path(forResource: name, ofType: "mp4") else {
            debugPrint(name + " not found")
            return []
        }
        let url = URL(fileURLWithPath: urlPath)
        let thumbURLPath = Bundle.main.path(forResource: name, ofType: "png")!
        let thumbURL = URL(fileURLWithPath: thumbURLPath)
        
        let video = Video(url: url, thumbURL: thumbURL, title: titles[index], subtitle: subtitles[index])
        videos.append(video)
          
      }
      return videos
    }
}
