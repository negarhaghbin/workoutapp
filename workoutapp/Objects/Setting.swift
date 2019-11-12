//
//  Setting.swift
//  workoutapp
//
//  Created by Negar on 2019-11-09.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit

class Settings: NSObject {
    var exerciseReminder: Bool
    var standupReminder: Bool
    var movingReminder: Bool
    
    init(exerciseReminder: Bool, standupReminder: Bool, movingReminder: Bool) {
      self.exerciseReminder = exerciseReminder
      self.standupReminder = standupReminder
      self.movingReminder = movingReminder
      super.init()
    }
    

}
