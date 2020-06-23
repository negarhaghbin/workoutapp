//
//  Step.swift
//  workoutapp
//
//  Created by Negar on 2020-05-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift
import HealthKit

class Step: Object {
    @objc dynamic var dateString : String = ""
    @objc dynamic var count : Int = 0
    
    override static func primaryKey() -> String? {
      return "dateString"
    }
    
    convenience init(dateString: String, count: Int) {
        self.init()
        let realm = try! Realm()
        try! realm.write {
            self.dateString = dateString
            self.count = count
        }
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    class func getWithDate() -> [String:[Step]] {
        let all = getAll()
        return Dictionary(grouping: all, by: {$0.dateString})
    }
    
    private class func getAll() -> [Step]{
        let realm = try! Realm()
        let allSteps = realm.objects(Step.self)
        return Array(allSteps)
    }
    
    class func getTotalStepsCount()->Int{
        let steps = Step.getAll()
        var totalStepCounts = 0
        for step in steps{
            totalStepCounts += step.count
        }
        return totalStepCounts
    }
    
    class func askAuthorization(completion: () -> ()){
        if HKHealthStore.isHealthDataAvailable() {
            let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!

            healthStore.requestAuthorization(toShare: [], read: [stepsCount]) { (success, error) in
                if success {
                    print("in success")
                }
                else {
                    if error != nil {
                        print(error ?? "")
                    }
                    print("Permission denied.")
                }
            }
            
            healthStore.enableBackgroundDelivery(for: stepsCount, frequency: .hourly, withCompletion: {(success, error) in
                if success {
                    print("Enabled background delivery of step changes")
                }
                else {
                    if error != nil {
                        print(error ?? "")
                    }
                    print("Permission denied.")
                }
                
            })
            
        }
        else{
            print("health not available")
        }
        completion()
    }
    
    class func update(){
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = Date().getWholeDate()

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let query = HKObserverQuery(sampleType: stepsQuantityType, predicate: predicate) { (query, completionHandler, errorOrNil) in
            if let error = errorOrNil {
                print("not authorized: \(error)")
                return
            }
            
            getStepsCount(){ steps in
                updateStepDB(date: Date(), steps: Int(steps))
            }
            completionHandler()
        }

        healthStore.execute(query)
    }
    
    private class func getStepsCount(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = Date().getWholeDate()

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(Double(-1))
                return
            }
            completion(Double(sum.doubleValue(for: HKUnit.count())))
        }

        healthStore.execute(query)
    }
    
    private class func updateStepDB(date: Date, steps: Int){
        let realm = try! Realm()
        if let step = realm.object(ofType: Step.self, forPrimaryKey: date.makeDateString()){
            try! realm.write {
                step.count = steps
            }
        }
        else{
               Step(dateString: date.makeDateString(), count: steps).add()
        }
    }
    
}
