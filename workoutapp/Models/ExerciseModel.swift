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
    @objc dynamic var equipmentsString : String = ""
    var equipments : Array<String> = []
    
    override static func primaryKey() -> String? {
      return "title"
    }
    
    func getEquipments()->Array<String>{
        var equipments : [String] = []
        if (self.equipmentsString != ""){
            equipments = self.equipmentsString.components(separatedBy: " ")
        }
        return equipments
    }
    
    class func initExerciseModelTable(realm: Realm){
        //let total =  "Total Body"
        //let upper = "Upper Body"
        let abs = "Abs"
        //let lower = "Lower Body"
        
        try! realm.write {
            realm.add(ExerciseModel(value: ["Crunch", abs, "crunch",  "https://www.youtube.com/watch?v=MKmrqcoCZ-M", 60,""]))
            realm.add(ExerciseModel(value: ["Air Bike Crunch", abs,  "air-bike-crunches",  "https://www.youtube.com/watch?v=jKT7-9L935g", 60,""] ))
            realm.add(ExerciseModel(value: ["Sitting Twist", abs, "sitting-twists",  "https://www.youtube.com/watch?v=wkD8rjkodUI", 10,""]))
            realm.add(ExerciseModel(value: ["Raised Leg Hold", abs,  "raised-leg-hold",  "https://www.youtube.com/watch?v=l4kQd9eWclE", 10,""] ))
            realm.add(ExerciseModel(value: ["High Plank Hold", abs, "plank-hold",  "https://www.youtube.com/watch?v=fSaYfvSpAMI", 10,""]))
            realm.add(ExerciseModel(value: ["Plank Leg Raise", abs,  "plank-leg-raise",  "https://www.youtube.com/watch?v=IexgiQZetb8", 20,""] ))
        }
    }
    
    class func loadExercises()->[ExerciseModel]{
        let realm = try? Realm()
        return Array(realm!.objects(ExerciseModel.self))
    }
}
