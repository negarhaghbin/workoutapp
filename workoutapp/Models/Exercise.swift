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
        }
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
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
        
        Exercise(name: "Crunches", type: abs).add()
        Exercise(name: "Air Bike Crunches", type: abs).add()
        Exercise(name: "Sitting Twists", type: abs).add()
        Exercise(name: "Raised Leg Hold", type: abs).add()
        Exercise(name: "High Plank Hold", type: abs).add()
        Exercise(name: "Plank Leg Raise", type: abs).add()
        
        
        Exercise(name: "Step Jacks", type: total).add()
        Exercise(name: "Knee to Elbow", type: total).add()
        Exercise(name: "Lunge Step-ups(left)", type: total).add()
        Exercise(name: "Lunge Step-ups(right)", type: total).add()
        Exercise(name: "Calf Raise", type: total).add()
        Exercise(name: "Bend and Twist(left)", type: total).add()
        Exercise(name: "Bend and Twist(right)", type: total).add()
        
        Exercise(name: "Butt Kicks", type: lower).add()
        Exercise(name: "March Steps", type: lower).add()
        Exercise(name: "Calf Raise Hold", type: lower).add()
        Exercise(name: "Standing Side Leg Raise", type: lower).add()
        Exercise(name: "Flutter Kicks", type: lower).add()
        Exercise(name: "Steps", type: lower).add()
        
        Exercise(name: "Clench/Unclench Overhead", type: upper).add()
        Exercise(name: "Clench/Unclench Arms Raised to the Side", type: upper).add()
        Exercise(name: "Raised Arm Circles", type: upper).add()
        Exercise(name: "Arms Raised to the Side Hold", type: upper).add()
        Exercise(name: "Bicep Extensions", type: upper).add()
        Exercise(name: "Bicep Extensions Hold", type: upper).add()
        
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
