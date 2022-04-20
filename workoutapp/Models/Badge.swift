//
//  Badge.swift
//  workoutapp
//
//  Created by Negar on 2020-05-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift


enum BadgeTitle : String {
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
    @objc dynamic var isNewlyAchieved : Bool = false
    
    convenience init(imageName: String, title: String, specification: String, d: Duration) {
        self.init()
        if let realm = try? Realm() {
            try? realm.write {
                self.imageName = imageName
                self.title = title
                self.specification = specification
                self.duration = d
            }
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
        Badge(imageName: "abs_boronz.png", title: BadgeTitle.bronzeAbs.rawValue, specification:"Complete 15 minutes of \(ExerciseType.abs.rawValue.lowercased()) workouts.", d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "abs_silver.png", title: BadgeTitle.silverAbs.rawValue, specification:"Complete 1 hour of \(ExerciseType.abs.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "abs_gold.png", title: BadgeTitle.goldAbs.rawValue, specification:"Complete 3 hours of \(ExerciseType.abs.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "lower_boronz.png", title: BadgeTitle.bronzeLegs.rawValue, specification:"Complete 15 minutes of \(ExerciseType.lower.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "lower_silver.png", title: BadgeTitle.silverLegs.rawValue, specification:"Complete 1 hour of \(ExerciseType.lower.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "lower_gold.png", title: BadgeTitle.goldLegs.rawValue, specification:"Complete 3 hours of \(ExerciseType.lower.rawValue.lowercased()) workouts.", d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "upper_boronz.png", title: BadgeTitle.bronzeArms.rawValue, specification:"Complete 15 minutes of \(ExerciseType.upper.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "upper_silver.png", title: BadgeTitle.silverArms.rawValue, specification:"Complete 1 hour of \(ExerciseType.upper.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "upper_gold.png", title: BadgeTitle.goldArms.rawValue, specification:"Complete 3 hours of \(ExerciseType.upper.rawValue.lowercased()) workouts.",d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
        Badge(imageName: "total_boronz.png", title: BadgeTitle.bronzeBody.rawValue, specification:"Complete 15 minutes of \(ExerciseType.total.rawValue.lowercased()) workouts.", d: Duration(durationInSeconds: BadgeDuration.bronze.rawValue)).add()
        Badge(imageName: "total_silver.png", title: BadgeTitle.silverBody.rawValue, specification:"Complete 1 hour of \(ExerciseType.total.rawValue.lowercased()) workouts.", d: Duration(durationInSeconds: BadgeDuration.silver.rawValue)).add()
        Badge(imageName: "total_gold.png", title: BadgeTitle.goldBody.rawValue, specification:"Complete 3 hours of \(ExerciseType.total.rawValue.lowercased()) workouts.", d: Duration(durationInSeconds: BadgeDuration.gold.rawValue)).add()
        
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
    
    class func getNewlyAchieved() -> [Badge]{
        let realm = try! Realm()
        return Array(realm.objects(Badge.self).filter("isNewlyAchieved == true"))
    }
    
    class func getNotAchieved() -> [Badge]{
        let realm = try! Realm()
        return Array(realm.objects(Badge.self).filter("isAchieved == false"))
    }
    
    class func resetNewlyAchieved(){
        let newlyAchieved = getNewlyAchieved()
        let realm = try! Realm()
        try! realm.write {
            for badge in newlyAchieved{
                badge.isNewlyAchieved = false
            }
        }
        
    }
    
    func achieved(){
        if (!self.isAchieved){
            let realm = try! Realm()
            let name = self.imageName.dropLast(4)
            try! realm.write {
                self.isAchieved = true
                self.isNewlyAchieved = true
                self.imageName = "\(name)_done.png"
                //not sure about this line
                self.progress = self.duration
            }
//            print(self.imageName)
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
        manageStepsBadge()
        let user = try! Realm().object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
        updateStreaksProgress(newStreak: user.streak)
        for (type, items) in diary{
            var temp = Duration()
            for item in items{
                temp = temp + item.duration!
            }
            updateBadge(type: type, duration: temp)
        }
        completion()
        
    }
    
    private class func manageStepsBadge(){
        let totalStepCounts = Step.getTotalStepsCount()
        
        let realm = try! Realm()
        var badge : Badge?
        
        if totalStepCounts >= BadgeDuration.bronzeS.rawValue{
            if totalStepCounts < BadgeDuration.silverS.rawValue{
                badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
                if (!badge!.isAchieved){
                    badge!.achieved()
                }
            }
            else{
                if totalStepCounts < BadgeDuration.goldS.rawValue {
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.silverShoes.rawValue)
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                }
                else{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.silverShoes.rawValue)
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.goldShoes.rawValue)
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                }
            }
        }
        let duration = Duration(countPerSet: totalStepCounts)
        badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.bronzeShoes.rawValue)
        badge!.updateProgress(duration: duration)
        badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.silverShoes.rawValue)
        badge!.updateProgress(duration: duration)
        badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.goldShoes.rawValue)
        badge!.updateProgress(duration: duration)
    }
    
    private class func updateBadge(type: String, duration: Duration){
        var name = ""
        switch type {
        case ExerciseType.upper.rawValue:
            name = "Arms"
        case ExerciseType.lower.rawValue:
            name = "Legs"
        case ExerciseType.total.rawValue:
            name = "Body"
        case ExerciseType.abs.rawValue:
            name = "Abs"
        default:
            print("unknown")
        }

        manageWorkoutBadges(name: name, duration: duration)
    }
    
    private class func manageWorkoutBadges(name: String, duration: Duration){
        let realm = try! Realm()
        var badge : Badge?
        if duration.durationInSeconds >= BadgeDuration.bronze.rawValue{
            if duration.durationInSeconds<BadgeDuration.silver.rawValue{
                badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                if (!badge!.isAchieved){
                    badge!.achieved()
                }
            }
            else{
                if duration.durationInSeconds<BadgeDuration.gold.rawValue{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                }
                else{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Golden \(name)")
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                    if (!badge!.isAchieved){
                        badge!.achieved()
                    }
                }
            }
            
        }
        badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
        badge!.updateProgress(duration: duration)
        badge = realm.object(ofType: Badge.self, forPrimaryKey: "Golden \(name)")
        badge!.updateProgress(duration: duration)
        badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
        badge!.updateProgress(duration: duration)
        
    }
    
    private class func updateStreaksProgress(newStreak: Int){
        let realm = try! Realm()
        var streakBadges : [Badge] = []
        streakBadges.append(realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak3.rawValue)!)
        streakBadges.append(realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak7.rawValue)!)
        streakBadges.append(realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak14.rawValue)!)
        streakBadges.append(realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak30.rawValue)!)
        
        for badge in streakBadges{
            badge.updateProgress(duration: Duration(streak:newStreak))
        }
        
    }
    
    private func updateProgress(duration: Duration){
        var progress : Duration?
        let realm = try! Realm()
        if (self.isAchieved){
            progress = self.duration
        }
        else{
            progress = duration
        }
        try! realm.write {
            self.progress = progress
        }
        
    }
    
    func getProgressBetween0and1()->(Float,String){
        var progressInNumber = Float(0.0)
        var progressInString = "0"
        if duration?.countPerSet == -1{
            if duration?.durationInSeconds == -1{
                if duration?.streak == -1{
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
