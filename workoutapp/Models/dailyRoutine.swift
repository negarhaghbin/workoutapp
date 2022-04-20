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

class DailyRoutine: Object {
    @objc dynamic var exerciseType: String
    @objc dynamic var seconds: Int
    @objc dynamic var performeDate: Double
//    @objc dynamic var dateString: String
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var feeling: String
    
    required override init() {
        exerciseType = ""
        seconds = 0
        performeDate = Date().timeIntervalSince1970
//        dateString = Date().makeDateString()
        feeling = ""
    }
    
    convenience init(exerciseType: String, durationInSeconds:Int , date: Double? = Date().timeIntervalSince1970, feeling: String? = "") {
        self.init()
        if let realm = try? Realm() {
            try? realm.write {
                self.exerciseType = exerciseType
                self.seconds = durationInSeconds
                self.performeDate = date!
                self.uuid = UUID().uuidString
                self.feeling = feeling!
            }
        }
    }
    
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    
    class func getAll() -> [DailyRoutine]{
        let realm = try! Realm()
        let allRoutines = realm.objects(DailyRoutine.self)
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
