//
//  notificationSettings.swift
//  workoutapp
//
//  Created by Negar on 2019-12-11.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications
import CoreMotion
import CoreLocation
//import HealthKit

class notificationSettings: Object {
    @objc dynamic var activity : Bool = true
    @objc dynamic var location : Bool = true
    @objc dynamic var timeBool : Bool = true
    @objc dynamic var time : String = "8:00"
    
    //static let healthStore = HKHealthStore()
//    private let activityManager = CMMotionActivityManager()
//    let motionManager = CMMotionManager()
//
    //private let pedometer = CMPedometer()

    func setTime(value: String){
        let realm = try! Realm()
        try! realm.write {
            self.time = value
        }
    }
    
    func setNotification(option: String, value: Bool){
        let realm = try! Realm()
        try! realm.write {
            switch option {
            case Notification.Activity.rawValue:
                self.activity = value
            case Notification.Location.rawValue:
                self.location = value
            case Notification.Time.rawValue:
                self.timeBool = value
            default:
                break
            }
        }
    }

    func getTime() -> String{
        return time
    }
    
    class func addNewSettings(granted: Bool)->notificationSettings{
        let appSettings = notificationSettings()
        let realm = try! Realm()
        try! realm.write {
            appSettings.activity = granted
            appSettings.location = granted
            appSettings.timeBool = granted
            realm.add(appSettings)
        }
        return appSettings
    }
    
    // MARK: Time Notification
    
     func setUpTimeNotification(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "It's time to do your daily exercises!"
        content.body = "Tap to start now."
        content.sound = UNNotificationSound.default

        var date = DateComponents()
        let timeArray = time.split(separator: ":")
        date.hour = Int(timeArray[0])
        date.minute = Int(timeArray[1])
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(identifier: Notification.Time.rawValue, content: content, trigger: trigger)
        center.add(request)
    }
    
    // MARK: Activity Notification
    
    func setUpActivityNotification(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Have you been active enough today?"
        content.body = "Tap to find out."
        content.sound = UNNotificationSound.default

        var date = DateComponents()
        _ = time.split(separator: ":")
        date.hour = Int(20)
        date.minute = Int(00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: content, trigger: trigger)
        center.add(request)
    }
    
//
//    class func getTodaysSteps(completion: @escaping (Double) -> Void) {
//        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        print(notificationSettings.healthStore.authorizationStatus(for: stepsQuantityType))
//        if(notificationSettings.healthStore.authorizationStatus(for: stepsQuantityType) == .sharingAuthorized){
//            print("authorized")
//        }
//        if(notificationSettings.healthStore.authorizationStatus(for: stepsQuantityType) == .notDetermined){
//            print("notdetermined")
//        }
//
//        if(notificationSettings.healthStore.authorizationStatus(for: stepsQuantityType) == .sharingDenied){
//            print("denied")
//        }
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        print(now)
//        print(startOfDay)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
//            guard let result = result, let sum = result.sumQuantity() else {
//                print(error)
//                completion(0.0)
//                return
//            }
//            print(sum)
//            completion(sum.doubleValue(for: HKUnit.count()))
//        }
//
//        notificationSettings.healthStore.execute(query)
//
//    }
//
////    func setUpEveningNotifications(){
////
////
////        var date = DateComponents()
////        date.hour = 12
////        date.minute = 41
////        getTodaysSteps(completion: { steps in
////            print(steps)
////        })
////        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
////
////        let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: UNMutableNotificationContent(), trigger: trigger)
////        center.add(request)
////
////    }
//
//    class func test4(){
//        notificationSettings.getTodaysSteps(completion: { steps in
//            print(steps)
//            if steps < 6000 {
//                let center = UNUserNotificationCenter.current()
//               let content = UNMutableNotificationContent()
//                content.title = "You haven't been active enough today..."
//                content.body = "Tap to start a routine."
//                content.sound = .default
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
//
//                let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: UNMutableNotificationContent(), trigger: trigger)
//                center.add(request)
//            }
//        })
//
//    }
//
////    func setUpEveningNotifications(){
////            let center = UNUserNotificationCenter.current()
////
////            var date = DateComponents()
////            date.hour = 12
////            date.minute = 41
////            test(completion:{ content in
////    //            print(content)
////                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
////
////                let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: content, trigger: trigger)
////                center.add(request)
////            })
////
////        }
////
////        func test(completion: @escaping (UNMutableNotificationContent) -> Void){
////            let content = UNMutableNotificationContent()
////            getTodaysSteps(completion: { steps in
////                print(steps)
////                if steps < 6000 {
////
////                    content.title = "You haven't been active enough today..."
////                    content.body = "Tap to start a routine."
////                    content.sound = .default
////                }
////                completion(content)
////            })
////
////        }
//
//    func setUpActivityNotification(){
////        if CMMotionActivityManager.isActivityAvailable() {
////            updateActivity()
////        }
////        motionManager.startAccelerometerUpdates()
//        if HKHealthStore.isHealthDataAvailable() {
//            print("healthkit is available")
//            //setUpEveningNotifications()
//        }
//
//    }
//
////    @objc func updateActivity(){
////        activityManager.startActivityUpdates(to: OperationQueue.main) {
////            (activity: CMMotionActivity?) in
////            guard let activity = activity else { return }
////            DispatchQueue.main.async {
////                if activity.stationary {
////                    print("Stationary")
////                    //self.setUpTest()
////
////                } else {
////                    print("Automotive")
////                }
////            }
////        }
////    }
//
//    func setUpTest(){
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = "Are you ready to do your exercises?"
//        content.body = "Tap to start now."
//        content.sound = .default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//
//        let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: content, trigger: trigger)
//        center.add(request, withCompletionHandler: nil)
//    }
//
    // MARK: Location Notification
    class func setUpTimeIntervalNotification(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Are you ready to do your exercises?"
        content.body = "Tap to start now."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (20*60), repeats: false)

        let request = UNNotificationRequest(identifier: Notification.Location.rawValue, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    class func cancelNotification(identifier: String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == identifier {
                  identifiers.append(notification.identifier)
               }
           }
     UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
}
