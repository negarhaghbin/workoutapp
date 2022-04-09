//
//  BalloonAnimation.swift
//  workoutapp
//
//  Created by Negar on 2020-06-11.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import UIKit

func showCongratulationAnimation(balloon: Balloon) {
    var startTime: TimeInterval?
    var endTime: TimeInterval?
    let animationDuration = 3.0
    var height: CGFloat = 0
    var animationTimer: Timer?
    
    height = UIScreen.main.bounds.height + balloon.frame.size.height
    balloon.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: height + balloon.frame.size.height / 2)
    balloon.isHidden = false
    startTime = Date().timeIntervalSince1970
    endTime = animationDuration + startTime!
    animationTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { timer in
        updateAnimation(endTime: endTime!, startTime: startTime!, animationTimer: animationTimer!, balloon: balloon, animationDuration: animationDuration, height: height)
    }
}

func updateAnimation(endTime: TimeInterval, startTime: TimeInterval, animationTimer: Timer, balloon:Balloon, animationDuration: Double, height: CGFloat) {
      let now = Date().timeIntervalSince1970

      if now >= endTime {
        animationTimer.invalidate()
        balloon.isHidden = true
      }

      let percentage = (now - startTime) * 100 / animationDuration
      let y = height - ((height + balloon.frame.height / 2) / 100 *
        CGFloat(percentage))
      
      balloon.center = CGPoint(x: balloon.center.x +
        CGFloat.random(in: -0.5...0.5), y: y)
}
