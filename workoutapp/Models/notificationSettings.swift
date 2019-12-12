//
//  notificationSettings.swift
//  workoutapp
//
//  Created by Negar on 2019-12-11.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class notificationSettings: Object {
    @objc dynamic var location : Bool = true
    @objc dynamic var timeBool : Bool = true
    @objc dynamic var time : String = "08:00"
    
    func setLocation(value: Bool){
        self.location = value
    }
    func setTime(value: Bool){
        self.timeBool = value
    }
    func setTime(value: String){
        self.time = value
    }
    func isLocationEnabled() -> Bool{
        return location
    }
    func isTimeEnabled() -> Bool{
        return timeBool
    }
    func getTime() -> String{
        return time
    }
    
}
