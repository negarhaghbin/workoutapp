//
//  Exercise.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class Exercise: Object {
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var compoundKey = ""
    
    override static func primaryKey() -> String? {
      return "compoundKey"
    }
    
    convenience init(name: String, type: String) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.name = name
            self.type = type
            self.compoundKey = compoundKeyValue()
            realm.add(self)
        }
    }
    
    func compoundKeyValue() -> String {
        return "\(name)\(type)"
    }
    
    class func isNew(ck: String)->Bool{
        if (try! Realm().object(ofType: Exercise.self, forPrimaryKey: ck)) != nil{
            return false
        }
        else{
            return true
        }
    }
    
    class func initExerciseTable(){
        
        let total =  "Total Body"
        let upper = "Upper Body"
        let abs = "Abs"
        let lower = "Lower Body"
        
        Exercise(name: "Crunches", type: abs)
        Exercise(name: "Air Bike Crunches", type: abs)
        Exercise(name: "Sitting Twists", type: abs)
        Exercise(name: "Raised Leg Hold", type: abs)
        Exercise(name: "High Plank Hold", type: abs)
        Exercise(name: "Plank Leg Raise", type: abs)
        
        
        Exercise(name: "Step Jacks", type: total)
        Exercise(name: "Knee to Elbow", type: total)
        Exercise(name: "Lunge Step-ups(left)", type: total)
        Exercise(name: "Lunge Step-ups(right)", type: total)
        Exercise(name: "Calf Raise", type: total)
        Exercise(name: "Bend and Twist(left)", type: total)
        Exercise(name: "Bend and Twist(right)", type: total)
        
        Exercise(name: "Butt Kicks", type: lower)
        Exercise(name: "March Steps", type: lower)
        Exercise(name: "Calf Raise Hold", type: lower)
        Exercise(name: "Standing Side Leg Raise", type: lower)
        Exercise(name: "Flutter Kicks", type: lower)
        Exercise(name: "Steps", type: lower)
        
        Exercise(name: "Clench/Unclench Overhead", type: upper)
        Exercise(name: "Clench/Unclench Arms Raised to the Side", type: upper)
        Exercise(name: "Raised Arm Circles", type: upper)
        Exercise(name: "Arms Raised to the Side Hold", type: upper)
        Exercise(name: "Bicep Extensions", type: upper)
        Exercise(name: "Bicep Extensions Hold", type: upper)
        
    }
    
    class func loadExercises()->[Exercise]{
        let realm = try? Realm()
        return Array(realm!.objects(Exercise.self))
    }
    
    class func getObject(ck: String)->Exercise{
        let realm = try? Realm()
        return realm!.object(ofType: Exercise.self, forPrimaryKey: ck)!
    }
    
    class func getCompoundKey(name: String, type: String) -> String{
        return "\(name)\(type)"
    }
    
}
