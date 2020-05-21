//
//  Badge.swift
//  workoutapp
//
//  Created by Negar on 2020-05-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class Badge: Object {
    @objc dynamic var imageName : String = ""
    @objc dynamic var title : String = ""
    //description?
    @objc dynamic var duration : Duration?
    
    convenience init(iname: String, title: String, d: Duration) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.imageName = iname
            self.title = title
            self.duration = d
        }
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    class func fillBadgeTable(){
        Badge(iname: "abs_boronz.png", title: "Bronzen Abs", d: Duration(sd: 15*60)).add()
        Badge(iname: "abs_silver.png", title: "Silver Abs", d: Duration(sd: 60*60)).add()
        Badge(iname: "abs_gold.png", title: "Golden Abs", d: Duration(sd: 3*60*60)).add()
    }
    
    class func getAll() -> [Badge]{
        let realm = try! Realm()
        return Array(realm.objects(Badge.self))
    }
}
