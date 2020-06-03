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
    
    case strike3 = "3 days"
    case strike7 = "7 days"
    case strike14 = "14 days"
    case strike30 = "30 days"
    
    case notifActivity = "Activity Notification!"
    case notifLocation = "Location Notification!"
    case notifTime = "Time Notification!"
}
class Badge: Object {
    @objc dynamic var imageName : String = ""
    @objc dynamic var title : String = ""
    //description?
    @objc dynamic var duration : Duration?
    @objc dynamic var isAchieved : Bool = false
    
    convenience init(iname: String, title: String, d: Duration) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.imageName = iname
            self.title = title
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
        Badge(iname: "abs_boronz.png", title: BadgeTitle.bronzeAbs.rawValue, d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "abs_silver.png", title: BadgeTitle.silverAbs.rawValue, d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "abs_gold.png", title: BadgeTitle.goldAbs.rawValue, d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        
        Badge(iname: "lower_boronz.png", title: BadgeTitle.bronzeLegs.rawValue, d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "lower_silver.png", title: BadgeTitle.silverLegs.rawValue, d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "lower_gold.png", title: BadgeTitle.goldLegs.rawValue, d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        
        Badge(iname: "upper_boronz.png", title: BadgeTitle.bronzeArms.rawValue, d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "upper_silver.png", title: BadgeTitle.silverArms.rawValue, d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "upper_gold.png", title: BadgeTitle.goldArms.rawValue, d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        
        Badge(iname: "total_boronz.png", title: BadgeTitle.bronzeBody.rawValue, d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "total_silver.png", title: BadgeTitle.silverBody.rawValue, d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "total_gold.png", title: BadgeTitle.goldBody.rawValue, d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        
        Badge(iname: "strike_3days.png", title: BadgeTitle.strike3.rawValue, d: Duration(strike: 3)).add()
        Badge(iname: "strike_7days.png", title: BadgeTitle.strike7.rawValue, d: Duration(strike: 7)).add()
        Badge(iname: "strike_14days.png", title: BadgeTitle.strike14.rawValue, d: Duration(strike: 14)).add()
        Badge(iname: "strike_30days.png", title: BadgeTitle.strike30.rawValue, d: Duration(strike: 30)).add()
        
        Badge(iname: "steps_boronz.png", title: BadgeTitle.bronzeShoes.rawValue, d: Duration(isc: BadgeDuration.bronzeS.rawValue)).add()
        Badge(iname: "steps_silver.png", title: BadgeTitle.silverShoes.rawValue, d: Duration(isc: BadgeDuration.silverS.rawValue)).add()
        Badge(iname: "steps_gold.png", title: BadgeTitle.goldShoes.rawValue, d: Duration(isc: BadgeDuration.goldS.rawValue)).add()
        
        Badge(iname: "notif_activity.png", title: BadgeTitle.notifActivity.rawValue, d: Duration(isc: 1)).add()
        Badge(iname: "notif_location.png", title: BadgeTitle.notifLocation.rawValue, d: Duration(isc: 1)).add()
        Badge(iname: "notif_time.png", title: BadgeTitle.notifTime.rawValue, d: Duration(isc: 1)).add()
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
                temp += item.duration!.secDuration
                if type == ExerciseType.lower.rawValue{
                    if item.exercise?.name == "Steps"{
                        totalSteps += item.duration!.inSetCount
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
            }
            else{
                if duration<BadgeDuration.gold.rawValue{
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Silver \(name)")
                    badge!.achieved()
                    badge = realm.object(ofType: Badge.self, forPrimaryKey: "Bronze \(name)")
                    badge!.achieved()
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
    }
}
