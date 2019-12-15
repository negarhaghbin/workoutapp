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
    @objc dynamic var activity : Bool = true
    @objc dynamic var location : Bool = true
    @objc dynamic var timeBool : Bool = true
    @objc dynamic var time : String = "08:00"
    
    func setActivity(value: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.activity = value
        }
    }
    
    func setLocation(value: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.location = value
        }
    }
    func setTime(value: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.timeBool = value
        }
    }
    func setTime(value: String){
        let realm = try! Realm()
        try! realm.write {
            self.time = value
        }
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
