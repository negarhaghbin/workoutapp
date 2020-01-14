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
    @objc dynamic var identifier : String
    @objc dynamic var dateString : String
    
    required init() {
        identifier = ""

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateString = df.string(from: Date())
    }
    
    func add(identifier: String){
        let realm = try! Realm()
        try! realm.write {
            self.identifier = identifier
            realm.add(self)
        }
    }
    
    class func getAll() -> [Interaction]{
        let realm = try! Realm()
        let allInteractions = realm.objects(Interaction.self)
        return Array(allInteractions)
    }
    
}
