//
//  User.swift
//  workoutapp
//
//  Created by Negar on 2019-11-11.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var name = ""
    @objc dynamic var uuid : String = UUID().uuidString
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    class func createUser(name: String){
        let realm = try! Realm()
        let user = User()
        try! realm.write {
            user.name = name
            realm.add(user)
        }
        UserDefaults.standard.set(user.uuid, forKey: "uuid")
    }
}
