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
    let steps: [(Int,String)]
    let section: String

    init(url: URL, thumbURL: URL, title: String, subtitle: String, steps:[(Int,String)], section: String) {
      self.url = url
      self.thumbURL = thumbURL
      self.title = title
      self.subtitle = subtitle
      self.steps=steps
      self.section=section
      super.init()
    }
    
    class func localVideos() -> [Video] {
      var videos: [Video] = []
      let names = [ "stepsAndPulls", "armCircles", "doubleChopKneePulls", "InnerTightLift", "alternatingLunges"]
      let titles = [ "Lateral Steps And Pulls" , "Arm Circles", "Double Chop Knee Pulls", "Inner Thight Lift", "Alternating Lunges"]
      let subtitles = ["Duration: 30 seconds \nEquipment: No Equipment", "Duration: 60 seconds (30 seconds each direction) \nEquipment: No Equipment",
                       "Duration: 50 seconds (30 seconds each direction) \nEquipment: No Equipment",
                       "Duration: 80 seconds (40 seconds each side) \nEquipment: No Equipment", "Duration: 25 seconds \nEquipment: No Equipment"]
        let sections = ["Total Body", "Upper Body", "Abs", "Lower Body", "Lower Body" ]
        let allSteps = [
            [(1,"step 1"), (2,"step 2"), (3,"step 3")],
            [(1,"step 1"), (2,"step 2"), (3,"step 3")],
            [(1,"step 1"), (2,"step 2"), (3,"step 3")],
            [(1,"step 1"), (2,"step 2"), (3,"step 3")],
            [(1,"step 1"), (2,"step 2"), (3,"step 3")]
        ]
      
      for (index, name) in names.enumerated() {
        guard let urlPath = Bundle.main.path(forResource: name, ofType: "mp4") else {
            debugPrint(name + " not found")
            return []
        }
        let url = URL(fileURLWithPath: urlPath)
        let thumbURLPath = Bundle.main.path(forResource: name, ofType: "png")!
        let thumbURL = URL(fileURLWithPath: thumbURLPath)
        
        let video = Video(url: url, thumbURL: thumbURL, title: titles[index], subtitle: subtitles[index], steps: allSteps[index], section: sections[index])
        videos.append(video)
          
      }
      return videos
    }
}
