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
        return Date().makeString()
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
            realm.add(self)
        }
    }
    
    class func initWithoutAdd(e: Exercise?, d: Duration, date: String? = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }()) -> DiaryItem {
        let di = DiaryItem()
        let realm = try! Realm()
        try! realm.write {
            di.exercise = e
            di.duration = d
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
    
    class func getWithType() -> [String:[DiaryItem]] {
        var result : [String:[DiaryItem]] = [:]
        let all = getAll()
        var types : Set<String> = []
        for item in all {
            types.insert(item.exercise!.type)
        }
        
        //var datesArray = Array(dates)
        
        for type in types{
            result[type] = []
        }
        
        for item in all{
            var temp: [DiaryItem] = result[item.exercise!.type]!
            temp.append(item)
            result.updateValue(temp, forKey: item.exercise!.type)!
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
            DiaryItem(e: item.exercise, d: Duration(durationInSeconds: item.durationInSeconds?.durationInSeconds))
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
        let predicate = NSPredicate(format: "dateString = %@ AND exercise = %@", Date().makeString(), stepsEx)
        let todayStepsDiaryItems = realm.objects(DiaryItem.self).filter(predicate)
        
        if todayStepsDiaryItems.count > 0{
            se = todayStepsDiaryItems.first!
            DiaryItem.update(uuid: se.uuid, e: se.exercise!, d: Duration(countPerSet: sd), date: se.dateString)
        }
        else{
            se = DiaryItem(e: stepsEx , d: Duration(countPerSet: sd))
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
