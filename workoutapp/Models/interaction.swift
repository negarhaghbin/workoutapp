//
//  Interaction.swift
//  workoutapp
//
//  Created by Negar on 2020-01-08.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Interaction: Object {
    @objc dynamic var identifier : String = ""
    @objc dynamic var dateString : String = {
        return Date().makeDateTimeString()
    }()
    
    convenience init(identifier: String) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.identifier = identifier
        }
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    class func getAll() -> [Interaction]{
        let realm = try! Realm()
        let allInteractions = realm.objects(Interaction.self)
        return Array(allInteractions)
    }
    
}
