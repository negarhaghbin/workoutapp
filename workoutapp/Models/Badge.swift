//
//  Badge.swift
//  workoutapp
//
//  Created by Negar on 2020-05-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

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
        Badge(iname: "abs_boronz.png", title: "Bronze Abs", d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "abs_silver.png", title: "Silver Abs", d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "abs_gold.png", title: "Golden Abs", d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        Badge(iname: "lower_boronz.png", title: "Bronze Legs", d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "lower_silver.png", title: "Silver Legs", d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "lower_gold.png", title: "Golden Legs", d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        Badge(iname: "upper_boronz.png", title: "Bronze Arms", d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "upper_silver.png", title: "Silver Arms", d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "upper_gold.png", title: "Golden Arms", d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        Badge(iname: "total_boronz.png", title: "Bronze Body", d: Duration(sd: BadgeDuration.bronze.rawValue)).add()
        Badge(iname: "total_silver.png", title: "Silver Body", d: Duration(sd: BadgeDuration.silver.rawValue)).add()
        Badge(iname: "total_gold.png", title: "Golden Body", d: Duration(sd: BadgeDuration.gold.rawValue)).add()
        Badge(iname: "strike_3days.png", title: "3 days", d: Duration(strike: 3)).add()
        Badge(iname: "strike_7days.png", title: "7 days", d: Duration(strike: 7)).add()
        Badge(iname: "strike_14days.png", title: "14 days", d: Duration(strike: 14)).add()
        Badge(iname: "strike_30days.png", title: "30 days", d: Duration(strike: 30)).add()
        Badge(iname: "steps_boronz.png", title: "Bronze Shoes", d: Duration(isc: BadgeDuration.bronzeS.rawValue)).add()
        Badge(iname: "steps_silver.png", title: "Silver Shoes", d: Duration(isc: BadgeDuration.silverS.rawValue)).add()
        Badge(iname: "steps_gold.png", title: "Golden Shoes", d: Duration(isc: BadgeDuration.goldS.rawValue)).add()
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
        let realm = try! Realm()
        try! realm.write {
            self.isAchieved = true
        }
    }
    
    class func update(){
        let diary = DiaryItem.getWithType()
        
        for (type, items) in diary{
            var temp = 0
            for item in items{
                temp += item.duration!.secDuration
            }
            updateBadge(type: type, duration: temp)
        }
        
    }
    
    private class func updateBadge(type: String, duration: Int){
        let realm = try! Realm()
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
