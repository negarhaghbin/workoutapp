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
    
    func getDescription()->String{
        var equipmentsS=""
        if (equipmentsString == ""){
            equipmentsS = "No Equipments"
        }
        else{
            equipmentsS = equipmentsString
        }
    
        return "\(durationS) seconds \u{2022} \(equipmentsS)"
    }
    
    class func initExerciseModelTable(realm: Realm){
        let total =  "Total Body"
        let upper = "Upper Body"
        let abs = "Abs"
        let lower = "Lower Body"
        
        try! realm.write {
            realm.add(ExerciseModel(value: ["Crunches", abs, "crunch",  "MKmrqcoCZ-M", 20,""]))
            realm.add(ExerciseModel(value: ["Air Bike Crunches", abs,  "air-bike-crunches",  "jKT7-9L935g", 20,""] ))
            realm.add(ExerciseModel(value: ["Sitting Twists", abs, "sitting-twists",  "wkD8rjkodUI", 15,""]))
            realm.add(ExerciseModel(value: ["Raised Leg Hold", abs,  "raised-leg-hold",  "l4kQd9eWclE", 20,""] ))
            realm.add(ExerciseModel(value: ["High Plank Hold", abs, "plank-hold",  "https://www.youtube.com/watch?v=fSaYfvSpAMI", 15,""]))
            realm.add(ExerciseModel(value: ["Plank Leg Raise", abs,  "plank-leg-raise",  "IexgiQZetb8", 20,""] ))
            
            
            realm.add(ExerciseModel(value: ["Step Jacks", total, "step-jacks",  "JHdVMkRBuRA", 40,""]))
            realm.add(ExerciseModel(value: ["Knee to Elbow", total,  "knee-to-elbows",  "FzH5nGwYQMA", 10,""] ))
            realm.add(ExerciseModel(value: ["Lunge Step-ups", total, "lunge-step-ups",  "KM6-6xTRpow", 10,""]))
            realm.add(ExerciseModel(value: ["Calf Raise", total,  "calf-raise",  "-M4-G8p8fmc", 10,""] ))
            realm.add(ExerciseModel(value: ["Bend and Twist", total, "bend-and-twist",  "r2RQoVp9fSk", 10,""]))
            
            realm.add(ExerciseModel(value: ["Butt Kicks", lower, "butt-kicks",  "oMW59TKZvaI", 20,""]))
            realm.add(ExerciseModel(value: ["March Steps", lower,  "march-steps",  "dt7FAEYRLC4", 20,""] ))
            realm.add(ExerciseModel(value: ["Calf Raise Hold", lower, "calf-raise-hold",  "-M4-G8p8fmc", 20,""]))
            realm.add(ExerciseModel(value: ["Standing Side Leg Raise", lower,  "standing-side-kicks",  "9oGUwrTh7Cs", 20,""] ))
            realm.add(ExerciseModel(value: ["Flutter Kicks", lower, "flutter-kicks",  "eEG9uXjx4vQ", 25,""]))
            
            realm.add(ExerciseModel(value: ["Clench/Unclench Overhead", upper, "clench-unclench-overhead",  "", 30,""]))
            realm.add(ExerciseModel(value: ["Clench/Unclench Arms Raised to the Side", upper,  "clench-unclench-side",  "", 60,""] ))
            realm.add(ExerciseModel(value: ["Raised Arm Circles", upper, "raised-arm-circles",  "", 30,""]))
            realm.add(ExerciseModel(value: ["Arms Raised to the Side Hold", upper,  "hold",  "", 60,""] ))
            realm.add(ExerciseModel(value: ["Bicep Extensions", upper, "bicep-extensions",  "", 30,""]))
            realm.add(ExerciseModel(value: ["Bicep Extensions Hold", upper, "bicep-extension-hold",  "", 60,""]))
        }
    }
    
    class func loadExercises()->[ExerciseModel]{
        let realm = try? Realm()
        return Array(realm!.objects(ExerciseModel.self))
    }
}
