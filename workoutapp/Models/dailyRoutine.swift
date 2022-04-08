//
//  User.swift
//  workoutapp
//
//  Created by Negar on 2019-11-11.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift

enum RoutineFeeling: String{
    case good = "good"
    case neutral = "neutral"
    case bad = "bad"
}

class dailyRoutine: Object {
    @objc dynamic var exerciseType : String
    @objc dynamic var seconds : Int
    @objc dynamic var dateString : String
    @objc dynamic var uuid : String = UUID().uuidString
    @objc dynamic var feeling : String
    
    required override init() {
        exerciseType = ""
        seconds = 0
        dateString = Date().makeDateString()
        feeling = ""
    }
    
    convenience init(exerciseType: String, durationInSeconds:Int , date: String? = {
        return Date().makeDateString()
        }(), feeling: String? = {
        return ""
        }()) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.exerciseType = exerciseType
            self.seconds = durationInSeconds
            self.dateString = date!
            self.uuid = UUID().uuidString
            self.feeling = feeling!
        }
    }
    
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    
    class func getAll() -> [dailyRoutine]{
        let realm = try! Realm()
        let allRoutines = realm.objects(dailyRoutine.self)
        return Array(allRoutines)
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    func setFeeling(feeling: String){
        let realm = try! Realm()
        try! realm.write {
            self.feeling = feeling
        }
    }
    
}
