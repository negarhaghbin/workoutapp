//
//  CustomeExercise.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class CustomeExercise: Object {
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    
    override static func primaryKey() -> String? {
      return "name"
    }
    
    convenience init(name: String, type: String) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.name = name
            self.type = type
            realm.add(self)
        }
    }
    
    class func isNew(name: String)->Bool{
        if (try! Realm().object(ofType: CustomeExercise.self, forPrimaryKey: name)) != nil{
            return false
        }
        else{
            return true
        }
    }
    
}
