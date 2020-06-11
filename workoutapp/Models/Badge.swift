//
//  Badge.swift
//  workoutapp
//
//  Created by Negar on 2020-05-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift


enum BadgeTitle : String{
    case bronzeAbs = "Bronze Abs"
    case bronzeLegs = "Bronze Legs"
    case bronzeArms = "Bronze Arms"
    case bronzeBody = "Bronze Body"
    case bronzeShoes = "Bronze Shoes"
    
    case silverAbs = "Silver Abs"
    case silverLegs = "Silver Legs"
    case silverArms = "Silver Arms"
    case silverBody = "Silver Body"
    case silverShoes = "Silver Shoes"
    
    case goldAbs = "Golden Abs"
    case goldLegs = "Golden Legs"
    case goldArms = "Golden Arms"
    case goldBody = "Golden Body"
    case goldShoes = "Golden Shoes"
    
    case streak3 = "3 days"
    case streak7 = "7 days"
    case streak14 = "14 days"
    case streak30 = "30 days"
    
    case notifActivity = "Activity Notification!"
    case notifLocation = "Location Notification!"
    case notifTime = "Time Notification!"
}
class Badge: Object {
    @objc dynamic var imageName : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var specification : String = ""
    @objc dynamic var duration : Duration?
    @objc dynamic var isAchieved : Bool = false
    @objc dynamic var progress : Duration? = Duration()
    
    convenience init(imageName: String, title: String, specification: String, d: Duration) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.imageName = imageName
            self.title = title
            self.specification = specification
            self.duration = d
        }
    }
    
    override static func primaryKey() -> String? {
      return "title"
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    class func fillBadgeTable(){
        Badge(imageName: "abs_boronz.png", title: BadgeTitle.bronzeAbs.rawValue, specification:"Complete 15 minutes of abs workouts.", d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "abs_silver.png", title: BadgeTitle.silverAbs.rawValue, specification:"Complete 1 hour of abs workouts.",d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "abs_gold.png", title: BadgeTitle.goldAbs.rawValue, specification:"Complete 3 hours of abs workouts.",d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "lower_boronz.png", title: BadgeTitle.bronzeLegs.rawValue, specification:"Complete 15 minutes of lower body workouts.",d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "lower_silver.png", title: BadgeTitle.silverLegs.rawValue, specification:"Complete 1 hour of lower body workouts.",d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "lower_gold.png", title: BadgeTitle.goldLegs.rawValue, specification:"Complete 3 hours of abs workouts.", d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "upper_boronz.png", title: BadgeTitle.bronzeArms.rawValue, specification:"Complete 15 minutes of upper body workouts.",d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "upper_silver.png", title: BadgeTitle.silverArms.rawValue, specification:"Complete 1 hour of abs workouts.",d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "upper_gold.png", title: BadgeTitle.goldArms.rawValue, specification:"Complete 3 hours of upper body workouts.",d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "total_boronz.png", title: BadgeTitle.bronzeBody.rawValue, specification:"Complete 15 minutes of total body workouts.", d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "total_silver.png", title: BadgeTitle.silverBody.rawValue, specification:"Complete 1 hour of total body workouts.", d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "total_gold.png", title: BadgeTitle.goldBody.rawValue, specification:"Complete 3 hours of total body workouts.", d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "streak_3days.png", title: BadgeTitle.streak3.rawValue, specification:"Reach a 3 day streak.", d: Duration(streak: 3)).add()
        Badge(imageName: "streak_7days.png", title: BadgeTitle.streak7.rawValue, specification:"Reach a 7 day streak.", d: Duration(streak: 7)).add()
        Badge(imageName: "streak_14days.png", title: BadgeTitle.streak14.rawValue, specification:"Reach a 14 day streak.", d: Duration(streak: 14)).add()
        Badge(imageName: "streak_30days.png", title: BadgeTitle.streak30.rawValue, specification:"Reach a 30 day streak.", d: Duration(streak: 30)).add()
        
        Badge(imageName: "steps_boronz.png", title: BadgeTitle.bronzeShoes.rawValue, specification:"Complete 10k steps.", d: Duration(countPerSet: BadgeDuration.bronzeS.rawValue)).add()
        Badge(imageName: "steps_silver.png", title: BadgeTitle.silverShoes.rawValue, specification:"Complete 100k steps.", d: Duration(countPerSet: BadgeDuration.silverS.rawValue)).add()
        Badge(imageName: "steps_gold.png", title: BadgeTitle.goldShoes.rawValue, specification:"Complete 300k steps.", d: Duration(countPerSet: BadgeDuration.goldS.rawValue)).add()
        
        Badge(imageName: "notif_activity.png", title: BadgeTitle.notifActivity.rawValue, specification:"Tap on an activity-based notification.", d: Duration(countPerSet: 1)).add()
        Badge(imageName: "notif_location.png", title: BadgeTitle.notifLocation.rawValue, specification:"Tap on a location-based notification.", d: Duration(countPerSet: 1)).add()
        Badge(imageName: "notif_time.png", title: BadgeTitle.notifTime.rawValue, specification:"Tap on a time-based notification.", d: Duration(countPerSet: 1)).add()
    }
    
    class func getAll() -> [Badge]{
        let realm = try! Realm()
        return Array(realm.objects(Badge.self))
    }
    
    class func getAchieved() -> [Badge]{
        let realm = try! Realm()
        return Array(realm.objects(Badge.self).filter("isAchieved == true"))
    }
    
    class func getNotAchieved() -> [Badge]{
        let realm = try! Realm()
        return Array(realm.objects(Badge.self).filter("isAchieved == false"))
    }
    
    func achieved(){
        if (!self.isAchieved){
            let realm = try! Realm()
            let name = self.imageName.dropLast(4)
            try! realm.write {
                self.isAchieved = true
                self.imageName = "\(name)_done.png"
            }
            print(self.imageName)
        }
        
    }
    
    class func achieved(notificationID: String){
        let realm = try! Realm()
        var badge : Badge?
        
        switch notificationID {
        case Notification.Activity.rawValue:
            badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.notifActivity.rawValue)
        case Notification.Time.rawValue:
            badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.notifTime.rawValue)
        case Notification.Location.rawValue:
            badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.notifLocation.rawValue)
        default:
            print("unknown notification badge")
        }
        
        badge!.achieved()
    }
    
    class func update(completion: () -> ()){
        let diary = DiaryItem.getWithType()
        var totalSteps = 0
        for (type, items) in diary{
            var temp = 0
            for item in items{
                temp += item.duration!.durationInSeconds
                if type == ExerciseType.lower.rawValue{
                    if item.exercise?.name == "Steps"{
                        totalSteps += item.duration!.countPerSet
                    }
                }
            }
            updateBadge(type: type, duration: temp, steps: totalSteps)
        }
        completion()
        
    }
    
    private class func manageStepsBadge(steps: Int){
        let realm = try! Realm()
        var badge : Badge?
        
        if steps >= BadgeDuration.bronzeS.rawValue{
            if steps < BadgeDuration.silverS.rawValue{
                badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
                badge!.achieved()
            }
            else{
                if steps < BadgeDuration.goldS.rawValue {
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.silverShoes.rawValue)
                    badge!.achieved()
                }
                else{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.silverShoes.rawValue)
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.goldShoes.rawValue)
                    badge!.achieved()
                }
            }
        }
    }
    
    private class func updateBadge(type: String, duration: Int, steps: Int){
        let realm = try! Realm()
        var name = ""
        switch type {
        case ExerciseType.upper.rawValue:
            name = "Arms"
        case ExerciseType.lower.rawValue:
            name = "Legs"
            manageStepsBadge(steps: steps)
        case ExerciseType.total.rawValue:
            name = "Body"
        case ExerciseType.abs.rawValue:
            name = "Abs"
        default:
            print("unknown")
        }
        
        var badge : Badge?
        if duration >= BadgeDuration.bronze.rawValue{
            if duration<BadgeDuration.silver.rawValue{
                badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                badge!.achieved()
                badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
                badge!.updateProgress(duration: duration)
            }
            else{
                if duration<BadgeDuration.gold.rawValue{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Golden \(name)")
                    badge!.updateProgress(duration: duration)
                }
                else{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Golden \(name)")
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                    badge!.achieved()
                }
            }
            
        }
        else{
            badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
            badge!.updateProgress(duration: duration)
        }
    }
    
    func updateProgress(duration: Int){
        var progress : Duration?
        let realm = try! Realm()
        if (self.isAchieved){
            progress = self.duration
        }
        else{
            progress = Duration(durationInSeconds: duration)
        }
        try! realm.write {
            self.progress = progress
        }
        
    }
    
    func getProgressBetween0and1()->(Float,String){
        var progressInNumber = Float(0.0)
        var progressInString = "0"
        if duration?.countPerSet == 0{
            if duration?.durationInSeconds == 0{
                if duration?.streak == 0{
                    print("unknown progress!!")
                }
                else{
                    progressInNumber = (Float(self.progress!.streak) / Float(self.duration!.streak))
                    progressInString = "\(self.progress!.streak)/\(self.duration!.streak)"
                }
            }
            else{
                progressInNumber = Float(self.progress!.durationInSeconds) / Float(self.duration!.durationInSeconds)
                
                progressInString = String(format: "%.1f/\(Int(secondsToMinutes(seconds: self.duration!.durationInSeconds)))", secondsToMinutes(seconds:  self.progress!.durationInSeconds))
                
            }
        }
        else{
            if(!self.title.contains("Notification")){
                progressInNumber = Float(self.progress!.countPerSet) / Float(self.duration!.countPerSet)
                progressInString = String(format: "%.1fK/\(Int(thousandsToKs(number: self.duration!.countPerSet)))K", thousandsToKs(number: self.progress!.countPerSet))
                
            }
            else{
                progressInNumber = Float(self.progress!.countPerSet) / Float(self.duration!.countPerSet)
                progressInString = "\(self.progress!.countPerSet)/\( self.duration!.countPerSet)"
            }
        }
        return (progressInNumber,progressInString)
    }
}
