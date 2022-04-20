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
    @objc dynamic var numberOfSets: Int = -1
    @objc dynamic var countPerSet: Int = -1
    @objc dynamic var durationInSeconds: Int = -1
    @objc dynamic var streak: Int = -1
    
    convenience init(numberOfSets: Int? = -1, countPerSet: Int? = -1, durationInSeconds: Int? = -1, streak: Int? = -1) {
        self.init()
        if let realm = try? Realm() {
            try? realm.write {
                self.numberOfSets = numberOfSets!
                self.countPerSet = countPerSet!
                self.durationInSeconds = durationInSeconds!
                self.streak = streak!
            }
        }
    }
    
    private func getCount() -> String {
        if (numberOfSets < 0) {
            return (countPerSet < 0) ? "No sets" : "\(self.countPerSet)"
        } else {
            return "\(self.numberOfSets) sets of \(self.countPerSet)"
        }
    }
    
    func getTimeDuration() -> String {
        return (durationInSeconds < 0) ? "" : secondsToMSString(time: durationInSeconds)
    }
        
    func getDuration() -> String {
        return (getTimeDuration() == "") ? getCount() : getTimeDuration()
    }
    
    func increaseStreak() {
        if let realm = try? Realm() {
            try? realm.write {
                self.streak = self.streak + 1
            }
        }
    }
    
    static func +(left: Duration, right: Duration) -> Duration {
        let newNumberOfSets = left.numberOfSets + right.numberOfSets
        let newCountPerSet = left.countPerSet + right.countPerSet
        let newDurationInSeconds = left.durationInSeconds + right.durationInSeconds
        let newStreak = left.streak + right.streak
        
        return Duration(numberOfSets: newNumberOfSets, countPerSet: newCountPerSet, durationInSeconds: newDurationInSeconds, streak: newStreak)
    }
}
