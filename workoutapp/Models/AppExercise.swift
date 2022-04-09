//
//  AppExercise.swift
//  workoutapp
//
//  Created by Negar on 2019-11-19.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift


class AppExercise: Object {
    @objc dynamic var uuid : String = UUID().uuidString
    @objc dynamic var exercise: Exercise?
    
    @objc dynamic var gifName : String = ""
    @objc dynamic var videoURLString : String = ""
    @objc dynamic var durationInSeconds : Duration?
    @objc dynamic var equipmentsString : String = ""
    
    var equipments : Array<String> = []
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    convenience init(e: Exercise, g: String, v: String, d:Duration, eq: String) {
        self.init()
        if let realm = try? Realm() {
            try? realm.write {
                self.exercise = e
                self.gifName = g
                self.videoURLString = v
                self.durationInSeconds = d
                self.equipmentsString = eq
            }
        }
    }
    
    func add() {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(self)
            }
        }
    }
    
    func getEquipments() -> Array<String> {
        var equipments: [String] = []
        if (!self.equipmentsString.isEmpty){
            equipments = self.equipmentsString.components(separatedBy: " ")
        }
        return equipments
    }
    
    func getDescription() -> String {
        var equipmentsS = ""
        equipmentsS = equipmentsString.isEmpty ? "No Equipments" : equipmentsString
    
        return "\(durationInSeconds!.getDuration()) \u{2022} \(equipmentsS)"
    }
    
    func setDuration(d: Int){
        if let realm = try? Realm() {
            let duration = Duration(durationInSeconds: d)
            try? realm.write {
                self.durationInSeconds = duration
            }
        }
    }
    
    class func initAppExerciseTable(){
        if Exercise.loadExercises().isEmpty {
            Exercise.initExerciseTable()
        }
        let total =  "Total Body"
        let upper = "Upper Body"
        let abs = "Abs"
        let lower = "Lower Body"
        
        if let realm = try? Realm() {
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Crunches", type: abs))!, g: "crunch", v: "MKmrqcoCZ-M", d:  Duration(durationInSeconds: 30), eq: "").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Air Bike Crunches", type: abs))!, g:"air-bike-crunches",  v:"jKT7-9L935g", d: Duration(durationInSeconds: 30), eq:"" ).add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Sitting Twists", type: abs))!, g:"sitting-twists",  v:"wkD8rjkodUI", d: Duration(durationInSeconds: 30), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Raised Leg Hold", type: abs))!, g:"raised-leg-hold",  v:"l4kQd9eWclE", d: Duration(durationInSeconds: 30), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "High Plank Hold", type: abs))!, g:"plank-hold",  v:"fSaYfvSpAMI", d: Duration(durationInSeconds: 30), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Plank Leg Raise", type: abs))!, g:"plank-leg-raise",  v:"IexgiQZetb8", d: Duration(durationInSeconds: 30), eq:"").add()
                
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Step Jacks", type: total))!, g:"step-jacks",  v:"JHdVMkRBuRA", d: Duration(durationInSeconds: 40), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Knee to Elbow", type: total))!,  g:"knee-to-elbows",  v:"FzH5nGwYQMA", d: Duration(durationInSeconds: 30), eq:"").add()

            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Lunge Step-ups (Left)", type: total))!, g: "lunge-step-ups", v: "KM6-6xTRpow", d: Duration(durationInSeconds: 30), eq: "").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Lunge Step-ups (Right)", type: total))!, g: "lunge-step-ups", v: "KM6-6xTRpow", d: Duration(durationInSeconds: 30), eq: "").add()
            
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Calf Raise", type: total))!, g:"calf-raise",  v:"-M4-G8p8fmc", d: Duration(durationInSeconds: 30), eq:"").add()

            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Bend and Twist (Left)", type: total))!, g: "bend-and-twist", v: "r2RQoVp9fSk", d: Duration(durationInSeconds: 30), eq: "").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Bend and Twist (Right)", type: total))!, g: "bend-and-twist", v: "r2RQoVp9fSk", d: Duration(durationInSeconds: 30), eq: "").add()
                
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Butt Kicks", type: lower))!, g:"butt-kicks",  v:"oMW59TKZvaI", d: Duration(durationInSeconds: 20), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "March Steps", type: lower))!,  g:"march-steps",  v:"dt7FAEYRLC4", d: Duration(durationInSeconds: 20), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Calf Raise Hold", type: lower))!, g:"calf-raise-hold",  v:"-M4-G8p8fmc", d: Duration(durationInSeconds: 20), eq:"").add()
            AppExercise(e: realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Standing Side Leg Raise", type: lower))!,  g:"standing-side-kicks",  v:"9oGUwrTh7Cs", d: Duration(durationInSeconds: 20), eq:"").add()
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Flutter Kicks", type: lower)) {
                AppExercise(e: exercise, g:"flutter-kicks",  v:"eEG9uXjx4vQ", d: Duration(durationInSeconds: 25), eq:"").add()
            }
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Clench/Unclench Overhead", type: upper)) {
                AppExercise(e: exercise, g:"clench-unclench-overhead",  v:"", d: Duration(durationInSeconds: 30), eq:"").add()
            }
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Clench/Unclench Arms Raised to the Side", type: upper)) {
                AppExercise(e: exercise,  g:"clench-unclench-side",  v:"", d: Duration(durationInSeconds: 60), eq:"").add()
            }
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Raised Arm Circles", type: upper)) {
                AppExercise(e: exercise, g:"raised-arm-circles",  v:"", d: Duration(durationInSeconds: 30), eq:"").add()
            }
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Arms Raised to the Side Hold", type: upper)) {
                AppExercise(e: exercise, g:"hold", v:"", d: Duration(durationInSeconds: 60), eq:"").add()
            }
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Bicep Extensions", type: upper)) {
                AppExercise(e: exercise, g:"bicep-extensions", v:"", d: Duration(durationInSeconds: 30), eq:"").add()
            }
            
            if let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: Exercise.getCompoundKey(name: "Bicep Extensions Hold", type: upper)) {
                AppExercise(e: exercise, g:"bicep-extension-hold", v:"", d: Duration(durationInSeconds: 60), eq:"").add()
            }
        }
    }
    
    class func loadExercises()->[AppExercise]{
        let realm = try? Realm()
        return Array(realm!.objects(AppExercise.self))
    }
    
    class func hasExercise(name: String, type: String) -> Bool {
        let realm = try? Realm()
        let ck = Exercise.getCompoundKey(name: name, type: type)
        let e = Exercise.getObject(ck: ck)
        let predicate = NSPredicate(format: "exercise = %@", e)
        
        let result = realm!.objects(AppExercise.self).filter(predicate).first
        return (result != nil) ? true : false
    }
}
