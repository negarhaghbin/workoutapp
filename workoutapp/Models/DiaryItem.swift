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

let STEPPERSEC = 1.67
let healthStore = HKHealthStore()

class DiaryItem: Object {
    
    @objc dynamic var uuid : String = ""
    
    @objc dynamic var exercise: Exercise?
    @objc dynamic var durationS: String = ""
    @objc dynamic var dateString : String = {
        return Date().makeString()
    }()
    
    override static func primaryKey() -> String? {
      return "uuid"
    }
    
    convenience init(e: Exercise?, d: String, date: String? = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }()) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.uuid = UUID().uuidString
            self.exercise = e
            self.durationS = d
            self.dateString = date!
            realm.add(self)
        }
    }
    
    class func initWithoutAdd(e: Exercise?, d: String, date: String? = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }()) -> DiaryItem {
        let di = DiaryItem()
        let realm = try! Realm()
        try! realm.write {
            di.exercise = e
            di.durationS = d
            di.dateString = date!
            //realm.add(self)
        }
        return di
    }
    
    func isNew() -> Bool{
        if (try! Realm().object(ofType: DiaryItem.self, forPrimaryKey: uuid)) != nil{
            return false
        }
        return true
    }
    
    class func update(uuid: String, e: Exercise, d: String, date: String){
        let realm = try! Realm()
        var obj = realm.object(ofType: DiaryItem.self, forPrimaryKey: uuid)
        try! realm.write {
            if obj != nil{
                obj!.exercise = e
                obj!.durationS = d
                obj!.dateString = date
            }
            else{
                obj = DiaryItem()
                obj!.uuid = UUID().uuidString
                obj!.exercise = e
                obj!.durationS = d
                obj!.dateString = date
                realm.add(obj!)
            }
            
        }
    }
    
    class func getWithDate() -> [String:[DiaryItem]] {
        var result : [String:[DiaryItem]] = [:]
        let all = getAll()
        var dates : Set<String> = []
        for item in all {
            dates.insert(item.dateString)
        }
        
        //var datesArray = Array(dates)
        
        for date in dates{
            result[date] = []
        }
        
        for item in all{
            var temp: [DiaryItem] = result[item.dateString]!
            temp.append(item)
            result.updateValue(temp, forKey: item.dateString)!
        }
        
        return result
    }
    
    private class func getAll() -> [DiaryItem]{
        if HKHealthStore.isHealthDataAvailable() {
            let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!

            healthStore.requestAuthorization(toShare: [], read: [stepsCount]) { (success, error) in
                if success {
                    getStepsCount(forSpecificDate: Date()){ steps in
                        updateSteps(sd: steps)
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
        
        let realm = try! Realm()
        let allDiaryItems = realm.objects(DiaryItem.self)
        return Array(allDiaryItems)
    }
    
    class func add(appExList: [AppExercise]){
        for item in appExList {
            DiaryItem(e: item.exercise, d:SecondsToString(time: item.durationS))
        }
    }
    
    private class func updateSteps(sd: String){ //alan faghat male emruz ro update mikne
        let realm = try! Realm()
        let ck = Exercise.getCompoundKey(name: "Steps", type: "Lower Body")
        let stepsEx = Exercise.getObject(ck: ck)

        var se = DiaryItem()
        
        let predicate = NSPredicate(format: "dateString = %@ AND exercise = %@", Date().makeString(), stepsEx)
        let todayStepsDiaryItems = realm.objects(DiaryItem.self).filter(predicate)
        if todayStepsDiaryItems.count > 0{
            se = todayStepsDiaryItems.first!
            DiaryItem.update(uuid: se.uuid, e: se.exercise!, d: sd, date: se.dateString)
            
        }
        else{
            se = DiaryItem(e: stepsEx , d: sd)
        }

        
    }
    
    private class func getStepDuration(steps: Double)->String{
        let d = steps/STEPPERSEC
        return SecondsToString(time: Int(d))
    }
    
    
    private class func getStepsCount(forSpecificDate:Date, completion: @escaping (String) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = getWholeDate(date: forSpecificDate)

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion("empty")
                return
            }
            completion(DiaryItem.getStepDuration(steps: Double(sum.doubleValue(for: HKUnit.count()))))
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
