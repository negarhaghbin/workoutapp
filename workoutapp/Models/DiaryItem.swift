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
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
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
                if diaryItem.exercise?.name != "Steps"{
                    duration += diaryItem.duration!.durationInSeconds
                }
            }
            result[type]=duration
        }
        
        return result
    }
    
    private class func getAll() -> [DiaryItem]{
        addSteps()
        let realm = try! Realm()
        let allDiaryItems = realm.objects(DiaryItem.self)
        return Array(allDiaryItems)
    }
    
    class func add(appExList: [AppExercise]){
        for item in appExList {
            DiaryItem(e: item.exercise, d: Duration(durationInSeconds: item.durationInSeconds?.durationInSeconds)).add()
        }
    }
    
    class func addSteps(){
        if HKHealthStore.isHealthDataAvailable() {
            let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!

            healthStore.requestAuthorization(toShare: [], read: [stepsCount]) { (success, error) in
                if success {
                    getStepsCount(forSpecificDate: Date()){ steps in
                        updateSteps(sd: Int(steps))
                    }
                    
                }
                else {
                    if error != nil {
                        print(error ?? "")
                    }
                    print("Permission denied.")
                }
            }
            
        }
        else{
            print("health not available")
        }
    }
    
    private class func updateSteps(sd: Int){ //alan faghat male emruz ro update mikne
        let realm = try! Realm()
        let ck = Exercise.getCompoundKey(name: "Steps", type: "Lower Body")
        let stepsEx = Exercise.getObject(ck: ck)
        var se = DiaryItem()
        let predicate = NSPredicate(format: "dateString = %@ AND exercise = %@", Date().makeDateString(), stepsEx)
        let todayStepsDiaryItems = realm.objects(DiaryItem.self).filter(predicate)
        print("stepsssss: \(todayStepsDiaryItems)")
        if todayStepsDiaryItems.count > 0{
            se = todayStepsDiaryItems.first!
            DiaryItem.update(uuid: se.uuid, e: se.exercise!, d: Duration(countPerSet: sd), date: se.dateString)
        }
        else{
            se = DiaryItem(e: stepsEx , d: Duration(countPerSet: sd))
            se.add()
        }
    }
    
    
    private class func getStepsCount(forSpecificDate:Date, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = getWholeDate(date: forSpecificDate)

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(Double(sum.doubleValue(for: HKUnit.count())))
        }

        healthStore.execute(query)
    }

    private class func getWholeDate(date : Date) -> (startDate:Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate,endDate)
    }
    
    
    
}
