//
//  Duration.swift
//  workoutapp
//
//  Created by Negar on 2020-05-15.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class Duration: Object {
    @objc dynamic var setCount : Int = 0
    @objc dynamic var inSetCount : Int = 0
    @objc dynamic var durationS: String = ""
    
    convenience init(sc: Int? = {
        return 0
        }(), isc:Int? = {
        return 0
        }(), d: String? = {
        return ""
    }()) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.setCount = sc!
            self.inSetCount = isc!
            self.durationS = d!
        }
    }
    
    private func getCount()->String{
        if (setCount == 0){
            if (inSetCount == 0){
                return "No sets"
            }
            else{
                return "\(self.inSetCount)"
            }
        }
        else{
            return "\(self.setCount) sets of \(self.inSetCount)"
        }
    }
    
    func getDuration()->String{
        if (durationS == ""){
            return getCount()
        }
        else{
            return durationS
        }
    }
}
