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
        Badge(iname: "abs_boronz.png", title: "Bronzen Abs", d: Duration(sd: 15*60)).add()
        Badge(iname: "abs_silver.png", title: "Silver Abs", d: Duration(sd: 60*60)).add()
        Badge(iname: "abs_gold.png", title: "Golden Abs", d: Duration(sd: 3*60*60)).add()
        Badge(iname: "lower_boronz.png", title: "Bronzen Legs", d: Duration(sd: 15*60)).add()
        Badge(iname: "lower_silver.png", title: "Silver Legs", d: Duration(sd: 60*60)).add()
        Badge(iname: "lower_gold.png", title: "Golden Legs", d: Duration(sd: 3*60*60)).add()
        Badge(iname: "upper_boronz.png", title: "Bronzen Arms", d: Duration(sd: 15*60)).add()
        Badge(iname: "upper_silver.png", title: "Silver Arms", d: Duration(sd: 60*60)).add()
        Badge(iname: "upper_gold.png", title: "Golden Arms", d: Duration(sd: 3*60*60)).add()
        Badge(iname: "total_boronz.png", title: "Bronzen Body", d: Duration(sd: 15*60)).add()
        Badge(iname: "total_silver.png", title: "Silver Body", d: Duration(sd: 60*60)).add()
        Badge(iname: "total_gold.png", title: "Golden Body", d: Duration(sd: 3*60*60)).add()
        Badge(iname: "strike_3days.png", title: "3 days", d: Duration(strike: 3)).add()
        Badge(iname: "strike_7days.png", title: "7 days", d: Duration(strike: 7)).add()
        Badge(iname: "strike_14days.png", title: "14 days", d: Duration(strike: 14)).add()
        Badge(iname: "strike_30days.png", title: "30 days", d: Duration(strike: 30)).add()
        Badge(iname: "steps_boronz.png", title: "Bronzen Shoes", d: Duration(isc: 10000)).add()
        Badge(iname: "steps_silver.png", title: "Silver Shoes", d: Duration(isc: 100000)).add()
        Badge(iname: "steps_gold.png", title: "Golden Shoes", d: Duration(isc: 300000)).add()
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
}
