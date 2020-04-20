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
    @objc dynamic var bothSides : Bool = false
    
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
    
        return "\(SecondsToString(time: durationS)) \u{2022} \(equipmentsS)"
    }
    
    func setDuration(d: Int){
        let realm = try! Realm()
        try! realm.write {
            self.durationS = d
        }
    }
    
    class func initExerciseModelTable(){
        let realm = try! Realm()
        let total =  "Total Body"
        let upper = "Upper Body"
        let abs = "Abs"
        let lower = "Lower Body"
        
        try! realm.write {
            realm.add(ExerciseModel(value: ["Crunches", abs, "crunch",  "MKmrqcoCZ-M", 30,"", false]))
            realm.add(ExerciseModel(value: ["Air Bike Crunches", abs,  "air-bike-crunches",  "jKT7-9L935g", 30,"", false] ))
            realm.add(ExerciseModel(value: ["Sitting Twists", abs, "sitting-twists",  "wkD8rjkodUI", 30,"", false]))
            realm.add(ExerciseModel(value: ["Raised Leg Hold", abs,  "raised-leg-hold",  "l4kQd9eWclE", 30,"", false] ))
            realm.add(ExerciseModel(value: ["High Plank Hold", abs, "plank-hold",  "fSaYfvSpAMI", 30,"", false]))
            realm.add(ExerciseModel(value: ["Plank Leg Raise", abs,  "plank-leg-raise",  "IexgiQZetb8", 30,"", false] ))
            
            
            realm.add(ExerciseModel(value: ["Step Jacks", total, "step-jacks",  "JHdVMkRBuRA", 40,"", false]))
            realm.add(ExerciseModel(value: ["Knee to Elbow", total,  "knee-to-elbows",  "FzH5nGwYQMA", 30,"", false] ))
            realm.add(ExerciseModel(value: ["Lunge Step-ups", total, "lunge-step-ups",  "KM6-6xTRpow", 30,"", true]))
            realm.add(ExerciseModel(value: ["Calf Raise", total, "calf-raise",  "-M4-G8p8fmc", 30,"", false] ))
            realm.add(ExerciseModel(value: ["Bend and Twist", total, "bend-and-twist",  "r2RQoVp9fSk", 30,"", true]))
            
            realm.add(ExerciseModel(value: ["Butt Kicks", lower, "butt-kicks",  "oMW59TKZvaI", 20,"", false]))
            realm.add(ExerciseModel(value: ["March Steps", lower,  "march-steps",  "dt7FAEYRLC4", 20,"", false] ))
            realm.add(ExerciseModel(value: ["Calf Raise Hold", lower, "calf-raise-hold",  "-M4-G8p8fmc", 20,"", false]))
            realm.add(ExerciseModel(value: ["Standing Side Leg Raise", lower,  "standing-side-kicks",  "9oGUwrTh7Cs", 20,"", false] ))
            realm.add(ExerciseModel(value: ["Flutter Kicks", lower, "flutter-kicks",  "eEG9uXjx4vQ", 25,"", false]))
            
            realm.add(ExerciseModel(value: ["Clench/Unclench Overhead", upper, "clench-unclench-overhead",  "", 30,"", false]))
            realm.add(ExerciseModel(value: ["Clench/Unclench Arms Raised to the Side", upper,  "clench-unclench-side",  "", 60,"", false] ))
            realm.add(ExerciseModel(value: ["Raised Arm Circles", upper, "raised-arm-circles",  "", 30,"", false]))
            realm.add(ExerciseModel(value: ["Arms Raised to the Side Hold", upper,  "hold",  "", 60,"", false] ))
            realm.add(ExerciseModel(value: ["Bicep Extensions", upper, "bicep-extensions",  "", 30,"", false]))
            realm.add(ExerciseModel(value: ["Bicep Extensions Hold", upper, "bicep-extension-hold",  "", 60,"", false]))
        }
    }
    
    class func loadExercises()->[ExerciseModel]{
        let realm = try? Realm()
        return Array(realm!.objects(ExerciseModel.self))
    }
}
