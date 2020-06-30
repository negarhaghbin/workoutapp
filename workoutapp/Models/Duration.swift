//
//  Duration.swift
//  workoutapp
//
//  Created by Negar on 2020-05-15.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class Duration: Object {
    @objc dynamic var numberOfSets : Int = 0
    @objc dynamic var countPerSet : Int = 0
    @objc dynamic var durationInSeconds: Int = 0
    @objc dynamic var streak: Int = 0
    
    convenience init(numberOfSets: Int? = {
        return 0
        }(), countPerSet:Int? = {
        return 0
        }(), durationInSeconds: Int? = {
        return 0
        }(), streak: Int? = {
        return 0
        }()) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.numberOfSets = numberOfSets!
            self.countPerSet = countPerSet!
            self.durationInSeconds = durationInSeconds!
            self.streak = streak!
        }
    }
    
    private func getCount()->String{
        if (numberOfSets == 0){
            if (countPerSet == 0){
                return "No sets"
            }
            else{
                return "\(self.countPerSet)"
            }
        }
        else{
            return "\(self.numberOfSets) sets of \(self.countPerSet)"
        }
    }
    
    func getTimeDuration()->String{
        if (durationInSeconds==0){
            return ""
        }
        else{
            return SecondsToString(time: durationInSeconds)
        }
    }
        
    func getDuration()->String{
        if (getTimeDuration() == ""){
            return getCount()
        }
        else{
            return getTimeDuration()
        }
    }
    
    func increaseStreak(){
       let realm = try! Realm()
        try! realm.write {
            self.streak = self.streak + 1
        }
    }
    
    static func +(left: Duration, right: Duration)->Duration{
        return Duration(numberOfSets: left.numberOfSets + right.numberOfSets, countPerSet: left.countPerSet+right.countPerSet, durationInSeconds: left.durationInSeconds+right.durationInSeconds, streak: left.streak+right.streak)
    }
}
