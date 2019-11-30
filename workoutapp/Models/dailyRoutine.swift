//
//  User.swift
//  workoutapp
//
//  Created by Negar on 2019-11-11.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class dailyRoutine: Object {
    @objc dynamic var seconds : Int
    @objc dynamic var dateString : String
    
    required init() {
        self.seconds = 0
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.dateString = df.string(from: Date())
    }
    
    
    override static func primaryKey() -> String? {
      return "dateString"
    }
    
    class func get(realm: Realm) -> dailyRoutine{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        if let todayRoutine = realm.object(ofType: dailyRoutine.self, forPrimaryKey: df.string(from: Date())){
            return todayRoutine
        }
        else{
            try! realm.write {
                realm.add(dailyRoutine())
            }
            return realm.object(ofType: dailyRoutine.self, forPrimaryKey: df.string(from: Date()))!
        }
    }
    
    class func getAll() -> [dailyRoutine]{
        let realm = try? Realm()
        let allRoutines = realm!.objects(dailyRoutine.self)
        return Array(allRoutines)
    }
    
    class func update(seconds: Int){
        let realm = try? Realm()
        var routine = dailyRoutine.get(realm: realm!)
        
        try! realm!.write {
            routine.seconds += seconds
        }
    }
}
