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
    @objc dynamic var totalBodySeconds : Int
    @objc dynamic var upperBodySeconds : Int
    @objc dynamic var lowerBodySeconds : Int
    @objc dynamic var absSeconds : Int
    @objc dynamic var dateString : String
    
    required init() {
        totalBodySeconds = 0
        upperBodySeconds = 0
        lowerBodySeconds = 0
        absSeconds = 0
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.dateString = df.string(from: Date())
    }
    
    
    override static func primaryKey() -> String? {
      return "dateString"
    }
    
    func hasBeenActiveEnough()->String{
        if self.totalBodySeconds > 100{
            if self.upperBodySeconds > 100{
                if self.absSeconds > 100{
                    if self.lowerBodySeconds > 100{
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
    
    class func get() -> dailyRoutine{
        let realm = try! Realm()
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
        let realm = try! Realm()
        let allRoutines = realm.objects(dailyRoutine.self)
        return Array(allRoutines)
    }
    
    class func getAllDictionary() -> Dictionary<String, Int>{
        let allRoutines = getAll()
        var dict = Dictionary<String, Int>()
        dict["Total Body"]=0
        dict["Upper Body"]=0
        dict["Abs"]=0
        dict["Lower Body"]=0
        
        for routine in allRoutines{
            dict["Total Body"]! += (routine.totalBodySeconds)
            dict["Upper Body"]!+=routine.upperBodySeconds
            dict["Abs"]!+=routine.absSeconds
            dict["Lower Body"]!+=routine.lowerBodySeconds
        }
        return dict
    }
    
    class func update(seconds: Int, sectionTitle: String){
        let realm = try! Realm()
        let routine = dailyRoutine.get()
        try! realm.write {
            switch sectionTitle {
            case "Total Body":
                routine.totalBodySeconds += seconds
            case "Upper Body":
                routine.upperBodySeconds += seconds
            case "Abs":
                routine.absSeconds += seconds
            case "Lower Body":
                routine.lowerBodySeconds += seconds
            default:
                break
            }
        }
    }
    
    class func getDictionary()->Dictionary<String, Int>{
        var dict = Dictionary<String, Int>()
        let routine = dailyRoutine.get()
        dict["Total Body"]=routine.totalBodySeconds
        dict["Upper Body"]=routine.upperBodySeconds
        dict["Abs"]=routine.absSeconds
        dict["Lower Body"]=routine.lowerBodySeconds
        return dict
    }
}
