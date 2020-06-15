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
    @objc dynamic var exerciseType : String
    @objc dynamic var seconds : Int
    @objc dynamic var dateString : String
    @objc dynamic var uuid : String = UUID().uuidString
    
    required init() {
        self.exerciseType = ""
        seconds = 0
        self.dateString = Date().makeDateString()
    }
    
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    
    class func getAll() -> [dailyRoutine]{
        let realm = try! Realm()
        let allRoutines = realm.objects(dailyRoutine.self)
        return Array(allRoutines)
    }
    
    class func add(seconds: Int, sectionTitle: String){
        let realm = try! Realm()
        let newRoutine = dailyRoutine()
        try! realm.write {
            newRoutine.exerciseType = sectionTitle
            newRoutine.seconds = seconds
            realm.add(newRoutine)
        }
    }
    
}
