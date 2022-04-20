//
//  RealmManager.swift
//  workoutapp
//
//  Created by Negar on 2021-07-07.
//  Copyright © 2021 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager{
    static let realm = try! Realm()
    
    static func getUser() -> User {
        return realm.object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
    }
    
    static func getAppSettings() -> notificationSettings {
        return realm.objects(notificationSettings.self).first!
    }
    
    static func getBadge(primaryKey: String) -> Badge {
        return realm.object(ofType: Badge.self, forPrimaryKey: primaryKey)!
    }
}
