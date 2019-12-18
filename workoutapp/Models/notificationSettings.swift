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

class notificationSettings: Object {
    @objc dynamic var activity : Bool = true
    @objc dynamic var location : Bool = true
    @objc dynamic var timeBool : Bool = true
    @objc dynamic var time : String = "08:00"
    
    private let activityManager = CMMotionActivityManager()
    //let motionManager = CMMotionManager()
    //private let pedometer = CMPedometer()
    
    func getTimeBool() -> Bool{
        return self.timeBool
    }
    
    func setActivity(value: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.activity = value
        }
    }
    
    func setLocation(value: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.location = value
        }
    }
    func setTime(value: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.timeBool = value
        }
    }
    func setTime(value: String){
        let realm = try! Realm()
        try! realm.write {
            self.time = value
        }
    }
    func isLocationEnabled() -> Bool{
        return location
    }
    func isTimeEnabled() -> Bool{
        return timeBool
    }
    func getTime() -> String{
        return time
    }
    
    class func addNewSettings(){
        let appSettings = notificationSettings()
        let current = UNUserNotificationCenter.current()
        let realm = try! Realm()
        try! realm.write {
            realm.add(appSettings)
        }
    }
    
    func setUpTimeNotification(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Are you ready to do your exercises?"
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
    
    func setUpActivityNotification(){
        if CMMotionActivityManager.isActivityAvailable() {
            updateActivity()
        }
        //motionManager.startAccelerometerUpdates()
//        motionManager.startGyroUpdates()
//        motionManager.startMagnetometerUpdates()
//        motionManager.startDeviceMotionUpdates()
        //var timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateActivity), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateActivity(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            (activity: CMMotionActivity?) in
            
            guard let activity = activity else { return }
            print(dateFormatter.string(from: activity.startDate) )
            //print(self.motionManager.deviceMotionUpdateInterval)
            DispatchQueue.main.async {
                if activity.walking {
                    print("Walking")
                    
                } else if activity.stationary {
                    print("Stationary")
                    //print(activity.startDate)
                } else if activity.running {
                    print("Running")
                    //print(activity.startDate)
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
    }
    
    
    func disableNotification(identifier: String){
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
