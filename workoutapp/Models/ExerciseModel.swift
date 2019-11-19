//
//  ExerciseModel.swift
//  workoutapp
//
//  Created by Negar on 2019-11-19.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift


class ExerciseModel: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var section : String = ""
    @objc dynamic var gifName : String = ""
    @objc dynamic var videoURLString : String = ""
    @objc dynamic var durationS : Int = 0
    @objc dynamic var equipment : String = ""
    
    override static func primaryKey() -> String? {
      return "title"
    }
    
    class func initExerciseModelTable(realm: Realm){
        //let total =  "Total Body"
        //let upper = "Upper Body"
        let abs = "Abs"
        //let lower = "Lower Body"
        
        try! realm.write {
            realm.add(ExerciseModel(value: ["Crunch", abs, "crunch",  "https://www.youtube.com/watch?v=MKmrqcoCZ-M", 60, "No Equipments"]))
            realm.add(ExerciseModel(value: ["Air Bike Crunch", abs,  "air-bike-crunches",  "https://www.youtube.com/watch?v=jKT7-9L935g", 60, "No Equipments"] ))
        }
    }
    
    class func loadExercises()->[ExerciseModel]{
        let realm = try? Realm()
        return Array(realm!.objects(ExerciseModel.self))
    }
}
