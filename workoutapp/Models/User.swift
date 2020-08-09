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
    @objc dynamic var restDuration : Int = 20
    @objc dynamic var streak : Int = 1
    @objc dynamic var lastLogin : String = {
        return Date().makeDateString()
    }()
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    convenience init(n: String) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.name = n
        }
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
        UserDefaults.standard.set(self.uuid, forKey: "uuid")
    }
    
    func setRestDuration(rd: Int){
        let realm = try! Realm()
        try! realm.write {
            self.restDuration = rd
        }
    }
    
    func manageStreak(completion: () -> ()){
        let realm = try! Realm()
        if (self.lastLogin != Date.yesterday.makeDateString()){
            if lastLoginIsBefore(date: Date.yesterday.makeDateString()){
                try! realm.write {
                    self.streak = 1
                    self.lastLogin = Date().makeDateString()
                }
            }
        }
        else{
            try! realm.write {
                self.streak = self.streak + 1
                self.lastLogin = Date().makeDateString()
            }
        }
        completion()
        
    }
    
    func lastLoginIsBefore(date: String)->Bool{
        let lastLoginTuple = stringToDate(dateString: lastLogin)
        let dateTuple = stringToDate(dateString: date)
        if lastLoginTuple.0 < dateTuple.0{
            return true
        }
        else{
            if lastLoginTuple.1<dateTuple.1{
                return true
            }
            else{
                if lastLoginTuple.2 < dateTuple.2{
                    return true
                }
                else{
                    return false
                }
            }
        }
    }
}
