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
    //baraye har routine ye setoon dashte bashe
//    @objc dynamic var totalBodySeconds : Int
//    @objc dynamic var upperBodySeconds : Int
//    @objc dynamic var lowerBodySeconds : Int
//    @objc dynamic var absSeconds : Int
    @objc dynamic var exerciseType : String
    @objc dynamic var seconds : Int
    @objc dynamic var dateString : String
    @objc dynamic var uuid : String = UUID().uuidString
    
    required init() {
//        totalBodySeconds = 0
//        upperBodySeconds = 0
//        lowerBodySeconds = 0
//        absSeconds = 0
        self.exerciseType = ""
        seconds = 0
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.dateString = df.string(from: Date())
    }
    
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    class func hasBeenActiveEnough()->String{
        let todayRoutine = dailyRoutine.getToday()
        if getSeconds(section: ExerciseType.total.rawValue, todayRoutine:todayRoutine) > 100{
            if getSeconds(section: ExerciseType.upper.rawValue, todayRoutine:todayRoutine) > 100{
                if getSeconds(section: ExerciseType.abs.rawValue, todayRoutine:todayRoutine) > 100{
                    if getSeconds(section: ExerciseType.lower.rawValue, todayRoutine:todayRoutine) > 100{
                        return "yes"
                    }
                    else{
                        return "lower body"
                    }
                }
                else{
                    return "abs"
                }
            }
            else{
                return "upper body"
            }
        }
        else{
            return "total body"
        }
    }
    
    class func getToday() -> [dailyRoutine]{
        let realm = try! Realm()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        let todayRoutine = realm.objects(dailyRoutine.self).filter("dateString BEGINSWITH '\(df.string(from: Date()))'")
        return Array(todayRoutine)
    }
    
    private class func getSeconds(section: String, todayRoutine: [dailyRoutine])->Int{
        var result = 0
        if todayRoutine != []{
            for entry in todayRoutine{
                if entry.exerciseType == section{
                    result += entry.seconds
                }
            }
        }
        return result
    }
    
    class func getAll() -> [dailyRoutine]{
        let realm = try! Realm()
        let allRoutines = realm.objects(dailyRoutine.self)
        return Array(allRoutines)
    }
    
    class func getAllDictionary() -> Dictionary<String, Int>{
        let allRoutines = getAll()
        var dict = Dictionary<String, Int>()
        dict[ExerciseType.total.rawValue]=0
        dict[ExerciseType.upper.rawValue]=0
        dict[ExerciseType.abs.rawValue]=0
        dict[ExerciseType.lower.rawValue]=0
        
        for routine in allRoutines{
            switch routine.exerciseType {
            case ExerciseType.total.rawValue:
                dict[ExerciseType.total.rawValue]! += (routine.seconds)
            case ExerciseType.upper.rawValue:
            dict[ExerciseType.upper.rawValue]! += (routine.seconds)
            case ExerciseType.abs.rawValue:
            dict[ExerciseType.abs.rawValue]! += (routine.seconds)
            case ExerciseType.lower.rawValue:
            dict[ExerciseType.lower.rawValue]! += (routine.seconds)
            default:
                print("unknown exercise type")
                
            }
        }
        return dict
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
    
    class func getDictionary()->Dictionary<String, Int>{
        var dict = Dictionary<String, Int>()
        let routine = dailyRoutine.getToday()
        dict[ExerciseType.total.rawValue]=getSeconds(section: ExerciseType.total.rawValue, todayRoutine:routine)
        dict[ExerciseType.upper.rawValue]=getSeconds(section: ExerciseType.upper.rawValue, todayRoutine:routine)
        dict[ExerciseType.abs.rawValue]=getSeconds(section: ExerciseType.abs.rawValue, todayRoutine:routine)
        dict[ExerciseType.lower.rawValue]=getSeconds(section: ExerciseType.lower.rawValue, todayRoutine:routine)
        return dict
    }
}
