//
//  Diary.swift
//  workoutapp
//
//  Created by Negar on 2020-04-23.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift
import HealthKit

let healthStore = HKHealthStore()

class DiaryItem: Object {
    
    @objc dynamic var uuid : String = ""

    @objc dynamic var exercise: Exercise?
    @objc dynamic var duration : Duration? = Duration()
    @objc dynamic var dateString : String = {
        return Date().makeDateString()
    }()
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    convenience init(e: Exercise?, d:Duration , date: String? = {
        return Date().makeDateString()
    }()) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.uuid = UUID().uuidString
            self.exercise = e
            self.duration = d
            self.dateString = date!
        }
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    func isNew() -> Bool{
        if (try! Realm().object(ofType: DiaryItem.self, forPrimaryKey: uuid)) != nil{
            return false
        }
        return true
    }
    
    class func update(uuid: String, e: Exercise, d: Duration, date: String){
        let realm = try! Realm()
        var obj = realm.object(ofType: DiaryItem.self, forPrimaryKey: uuid)
        try! realm.write {
            if obj != nil{
                obj!.exercise = e
                obj!.duration = d
                obj!.dateString = date
            }
            else{
                obj = DiaryItem()
                obj!.uuid = UUID().uuidString
                obj!.exercise = e
                obj!.duration = d
                obj!.dateString = date
                realm.add(obj!)
            }
            
        }
    }
    
    func delete(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func hasBeenActiveEnough(In: String) -> Bool{
        let todaysDiaryTypeDurationDictionary = getDurationForTodayByType()
        let REQUIRED_ACTIVE_SECONDS = 100
        for (type, duration) in todaysDiaryTypeDurationDictionary{
            if In == type{
                if duration < REQUIRED_ACTIVE_SECONDS{
                    return false
                }
                else{
                    return true
                }
            }
        }
        return false
    }
    
    class func hasBeenActiveEnoughInTotal() -> Bool{
        for type in [ExerciseType.total.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue, ExerciseType.upper.rawValue]{
            if !DiaryItem.hasBeenActiveEnough(In: type){
                return false
            }
        }
        return true
    }
    
    class func getWithDate() -> [String:[DiaryItem]] {
        let all = getAll()
        return Dictionary(grouping: all, by: {$0.dateString})
    }
    
    class func getWithType() -> [String:[DiaryItem]] {
        let all = getAll()
        return Dictionary(grouping: all, by: {$0.exercise!.type})
    }
    
    class func getDurationForTodayByType() -> [String:Int] {
        let todaysDiaryItems = getWithDate()[Date().makeDateString()]
        let byType = Dictionary(grouping: todaysDiaryItems!, by: {$0.exercise!.type})
        var result : [String:Int] = [:]
        
        for (type, diaryItems) in byType{
            var duration = 0
            for diaryItem in diaryItems{
                duration += diaryItem.duration!.durationInSeconds
            }
            result[type]=duration
        }
        
        return result
    }
    
    private class func getAll() -> [DiaryItem]{
        let realm = try! Realm()
        let allDiaryItems = realm.objects(DiaryItem.self)
        return Array(allDiaryItems)
    }
    
    class func add(appExList: [AppExercise]){
        for item in appExList {
            DiaryItem(e: item.exercise, d: Duration(durationInSeconds: item.durationInSeconds?.durationInSeconds)).add()
        }
    }
    
}
