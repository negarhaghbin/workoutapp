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
    @objc dynamic var durationS : Int = 0
    @objc dynamic var equipmentsString : String = ""
    @objc dynamic var bothSides : Bool = false
    
    var equipments : Array<String> = []
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    convenience init(e: Exercise, g: String, v: String, d:Int, eq: String, b:Bool) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.exercise = e
            self.gifName = g
            self.videoURLString = v
            self.durationS = d
            self.equipmentsString = eq
            self.bothSides = b
            realm.add(self)
        }
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
    
    class func initAppExerciseTable(){
        if Exercise.loadExercises() == []{
            Exercise.initExerciseTable()
        }
        let realm = try? Realm()
        
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Crunches")!, g: "crunch", v: "MKmrqcoCZ-M", d: 30, eq: "", b: false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Air Bike Crunches")!, g:"air-bike-crunches",  v:"jKT7-9L935g", d:30, eq:"", b:false )
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Sitting Twists")!, g:"sitting-twists",  v:"wkD8rjkodUI", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Raised Leg Hold")!, g:"raised-leg-hold",  v:"l4kQd9eWclE", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "High Plank Hold")!, g:"plank-hold",  v:"fSaYfvSpAMI", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Plank Leg Raise")!, g:"plank-leg-raise",  v:"IexgiQZetb8", d:30, eq:"", b:false)
            
            
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Step Jacks")!, g:"step-jacks",  v:"JHdVMkRBuRA", d:40, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Knee to Elbow")!,  g:"knee-to-elbows",  v:"FzH5nGwYQMA", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Lunge Step-ups")!, g:"lunge-step-ups",  v:"KM6-6xTRpow", d:30, eq:"", b:true)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Calf Raise")!, g:"calf-raise",  v:"-M4-G8p8fmc", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Bend and Twist")!, g:"bend-and-twist",  v:"r2RQoVp9fSk", d:30, eq:"", b:true)
            
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Butt Kicks")!, g:"butt-kicks",  v:"oMW59TKZvaI", d:20, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "March Steps")!,  g:"march-steps",  v:"dt7FAEYRLC4", d:20, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Calf Raise Hold")!, g:"calf-raise-hold",  v:"-M4-G8p8fmc", d:20, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Standing Side Leg Raise")!,  g:"standing-side-kicks",  v:"9oGUwrTh7Cs", d:20, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Flutter Kicks")!, g:"flutter-kicks",  v:"eEG9uXjx4vQ", d:25, eq:"", b:false)
            
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Clench/Unclench Overhead")!, g:"clench-unclench-overhead",  v:"", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Clench/Unclench Arms Raised to the Side")!,  g:"clench-unclench-side",  v:"", d:60, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Raised Arm Circles")!, g:"raised-arm-circles",  v:"", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Arms Raised to the Side Hold")!, g:"hold", v:"", d:60, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Bicep Extensions")!, g:"bicep-extensions", v:"", d:30, eq:"", b:false)
        AppExercise(e: realm!.object(ofType: Exercise.self, forPrimaryKey: "Bicep Extensions Hold")!, g:"bicep-extension-hold", v:"", d:60, eq:"", b:false)

    }
    
    class func loadExercises()->[AppExercise]{
        let realm = try? Realm()
        return Array(realm!.objects(AppExercise.self))
    }
}
