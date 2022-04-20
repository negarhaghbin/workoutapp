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

enum NotificationCategoryID : String{
    case snoozable = "SNOOZABLE"
}
enum NotificationActionID : String{
    case notToday = "NOT_TODAY"
    case snooze = "SNOOZE"
}

class notificationSettings: Object {
    @objc dynamic var activity : Bool = true
    @objc dynamic var location : Bool = true
    @objc dynamic var locationSendAfter : Int = 15*60 //minutes
    @objc dynamic var timeBool : Bool = true
    @objc dynamic var time : String = "8:00"
    @objc dynamic var notFeelingItOn: Int = Int(Date().timeIntervalSince1970)

    func setTime(value: String) {
        if let realm = try? Realm() {
            try? realm.write {
                self.time = value
            }
        }
    }
    
    func setSendAfter(value: Int) {
        if let realm = try? Realm() {
            try? realm.write {
                self.locationSendAfter = value
            }
        }
    }
    
    func setNotFeelingItOn(date: Date) {
        if let realm = try? Realm() {
            try? realm.write {
                self.notFeelingItOn = Int(date.timeIntervalSince1970)
            }
        }
    }
    
    func doesFeelingItOn(date: Date) -> Bool {
        return !Calendar.current.isDate(date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(notFeelingItOn)))
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
    
     func setUpTimeNotification() {
         let content = UNMutableNotificationContent()
         
         let today = Int(Date().timeIntervalSince1970)
         let yesterday = Int(Date.yesterday.timeIntervalSince1970)
         
         let yesterdayExercises = try! Realm().objects(DiaryItem.self).filter("diaryItemDate > \(yesterday) AND diaryItemDate < \(today)")
         
         content.title = yesterdayExercises.isEmpty ? "Today is a new day!" : "It's time to do your daily exercises!"
         content.body = "Tap to start now."
         content.sound = UNNotificationSound.default
         content.categoryIdentifier = NotificationCategoryID.snoozable.rawValue
         
         var date = DateComponents()
         let timeArray = time.split(separator: ":")
         if !timeArray.isEmpty {
             date.hour = Int(timeArray[0])
             date.minute = Int(timeArray[1])
         }
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
         
         let request = UNNotificationRequest(identifier: Notification.Time.rawValue, content: content, trigger: trigger)
         UNUserNotificationCenter.current().add(request)
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
        //content.categoryIdentifier = Notification.Activity.rawValue
        content.categoryIdentifier = NotificationCategoryID.snoozable.rawValue

        var date = DateComponents()
        _ = time.split(separator: ":")
        date.hour = Int(20)
        date.minute = Int(00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(identifier: Notification.Activity.rawValue, content: content, trigger: trigger)
        center.add(request)
    }
    
    class func setupSnoozedNotification(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "It's time to do your daily exercises!"
        
        content.body = "Tap to start now."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = NotificationCategoryID.snoozable.rawValue
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 1, to: Date())
        
        let dateComponent = calendar.dateComponents([.hour,.minute], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

        let request = UNNotificationRequest(identifier: Notification.Time.rawValue, content: content, trigger: trigger)
        center.add(request)
    }
    
    class func cancelNotification(identifier: String){
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { notificationRequests in
           var identifiers: [String] = []
           for notificationRequest in notificationRequests {
               if notificationRequest.identifier == identifier {
                  identifiers.append(notificationRequest.identifier)
               }
           }
            center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
}
