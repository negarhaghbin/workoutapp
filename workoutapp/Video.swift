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
      let titles = [ "Lateral Steps And Pulls" , "Arm Circles", "Double Chop Knee Pulls", "Inner Thigh Lift", "Alternating Lunges"]
      let subtitles = ["Duration: 30 seconds \nEquipment: No Equipment", "Duration: 60 seconds \nEquipment: No Equipment",
                       "Duration: 50 seconds (30 seconds each direction) \nEquipment: No Equipment",
                       "Duration: 80 seconds (40 seconds each side) \nEquipment: No Equipment", "Duration: 25 seconds \nEquipment: No Equipment"]
        let sections = ["Total Body", "Upper Body", "Abs", "Lower Body", "Lower Body" ]
        let allSteps = [
            [(1,"Start with your feet a little wider than shoulder-width apart and bring both hands above your head."),
             (2,"Take a big step back with your left leg, crossing it to the right, bend the front knee and pull your arms back."),
             (3, "Return to the starting position and repeat on the opposite side.")],
            
            [(1,"Stand with your feet shoulder-width apart and extend your arms parallel to the floor."),
             (2,"Circle your arms forward using small controlled motions, gradually making the circles bigger until you feel a stretch in your triceps."),
             (3,"Reverse the direction of the circles after 30 seconds.")],
            
            [(1,"step 1"), (2,"step 2"), (3,"step 3")],
            
            [(1,"Lift your ribs and prop your head up on your hand. Be sure that you keep your back and neck in good alignment."),
            (2,"Put the foot of your top leg up in the back."),
            (3,"Bring your top hand in front of your body to keep your balance."),
            (4,"Inhale, and reach the bottom leg long, lifting it up off the floor. Keep it straight as you lift; do not bend the knee."),
            (5, "Exhale and maintain that sense of length as you lower the leg back down."),
            (6, "Repeat for a total of 40 seconds on each leg.")],
            
            
            [(1,"Start with your feet a little wider than shoulder-width apart and stand tall."),
             (2, "Step forward with your left leg and slowly lower your body until your front knee is bent at least 90 degrees, while your rear knee is just off the floor. Keep your torso upright the entire time."),
             (3,"Pause, then push off your left foot off the floor and return to the starting position as quickly as you can."),
             (4,"On your next rep, step forward with your right leg. Continue to alternate back and forth—doing one rep with your left, then one rep with your right.")]
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
