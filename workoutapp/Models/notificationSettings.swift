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
import CoreLocation

class notificationSettings: Object {
    @objc dynamic var activity : Bool = true
    @objc dynamic var location : Bool = true
    @objc dynamic var locationSendAfter : Int = 15*60 //minutes
    @objc dynamic var timeBool : Bool = true
    @objc dynamic var time : String = "8:00"

    func setTime(value: String){
        let realm = try! Realm()
        try! realm.write {
            self.time = value
        }
    }
    
    func setSendAfter(value: Int){
        let realm = try! Realm()
        try! realm.write {
            self.locationSendAfter = value
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
    
    class func getSettings()->notificationSettings{
        return try! Realm().objects(notificationSettings.self).first!
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
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let yesterday = df.string(from: Date.yesterday)
        
        if (try! Realm().object(ofType: dailyRoutine.self, forPrimaryKey: yesterday)) != nil{
            content.title = "It's time to do your daily exercises!"
        }
        
        else{
            content.title = "Today is a new day!"
        }
        
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
    
    func setUpActivityNotification(activity: String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        if activity == ""{
            content.title = "Have you been active enough today?"
            content.body = "Let's find out."
        }
        else{
            content.title = "Do you want to do \(activity) exercises?"
            content.body = "Tap to start now."
        }
        
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = Notification.Activity.rawValue

        var date = DateComponents()
        _ = time.split(separator: ":")
        date.hour = Int(20)
        date.minute = Int(00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: content, trigger: trigger)
        center.add(request)
    }
    // MARK: Location Notification
    
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
