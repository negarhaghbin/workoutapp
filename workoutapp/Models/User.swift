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
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var restDuration: Int = 20
    @objc dynamic var streak: Int = 1
    @objc dynamic var lastLogin: Int = Int(Date().timeIntervalSince1970)
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    convenience init(name: String) {
        self.init()
        if let realm = try? Realm() {
            try? realm.write {
                self.name = name
            }
        }
    }
    
    func add() {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(self)
            }
            UserDefaults.standard.set(self.uuid, forKey: "uuid")
        }
    }
    
    func changeName(newName: String) {
        if let realm = try? Realm() {
            try? realm.write {
                self.name = newName
            }
        }
    }
    
    class func getUser(uuid: String) -> User {
        if let realm = try? Realm() {
            if let user = realm.object(ofType: User.self, forPrimaryKey: uuid) {
                return user
            }
        }
        
        return User()
    }
    
    func setRestDuration(_ restDuration: Int) {
        if let realm = try? Realm() {
            try? realm.write {
                self.restDuration = restDuration
            }
        }
    }
    
    func manageStreak(completion: () -> ()) {
        if let realm = try? Realm() {
            if (!Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: TimeInterval(self.lastLogin)))) {
                if lastLoginIsBefore(date: Date.yesterday.timeIntervalSince1970) {
                    try? realm.write {
                        self.streak = 1
                        self.lastLogin = Int(Date().timeIntervalSince1970)
                    }
                }
            } else {
                try? realm.write {
                    self.streak = self.streak + 1
                    self.lastLogin = Int(Date().timeIntervalSince1970)
                }
            }
            completion()
        }
    }
    
    func lastLoginIsBefore(date: Double) -> Bool {
        return lastLogin < Int(date)
//        let lastLoginTuple = stringToDate(dateString: lastLogin)
//        let dateTuple = stringToDate(dateString: date)
//        return (lastLoginTuple.0 < dateTuple.0) ? true :
//        ((lastLoginTuple.1 < dateTuple.1) ? true :
//            (lastLoginTuple.2 < dateTuple.2 ? true : false))
    }
}
