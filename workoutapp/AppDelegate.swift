//
//  AppDelegate.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import RealmSwift
//import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let center = UNUserNotificationCenter.current()
    var appSettings : notificationSettings = notificationSettings()
    static let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if AppExercise.loadExercises() == []{
            AppExercise.initAppExerciseTable()
            Badge.fillBadgeTable()
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 0.96, green: 0.31, blue: 0.67, alpha: 1.0)
        center.delegate = self
        registerForPushNotifications()
        DiaryItem.addSteps()
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ applicvan: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func registerForPushNotifications() {
      center.requestAuthorization(options: [.alert, .sound, .badge]) {
        [weak self] granted, error in
        print("Permission granted: \(granted)")
        if self!.isNewUser(){
            self!.appSettings = notificationSettings.addNewSettings(granted: granted)
            if granted{
                self!.appSettings.setUpTimeNotification()
                self!.appSettings.setUpActivityNotification(activity: "")
            }
        }
        else{
            self!.appSettings = notificationSettings.getSettings()
            if self!.appSettings.timeBool{
                self!.appSettings.setUpTimeNotification()
            }
            if self!.appSettings.activity{
                self!.appSettings.setUpActivityNotification(activity: "")
            }
            
        }
        if granted{
            OperationQueue.main.addOperation{
                // Ask for Authorisation from the User.
                AppDelegate.locationManager.requestAlwaysAuthorization()
                
                // For use in foreground
                AppDelegate.locationManager.requestWhenInUseAuthorization()

                if CLLocationManager.locationServicesEnabled() {
                    AppDelegate.locationManager.delegate = self
                    AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    AppDelegate.locationManager.startUpdatingLocation()
                }
            }
            
        }
          guard granted else { return }
          self?.center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }
      }
        
    }
    
    func isNewUser()->Bool{
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return false
        }
        else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return true
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map {
            data in String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
//    func requestHealthKit(){
//        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
//        notificationSettings.healthStore.requestAuthorization(toShare: [], read: allTypes) { (success, error) in
//            if !success {
//                print("health not authorized")
//                self.appSettings.setNotification(option: Notification.Activity.rawValue, value: false)
//            }
//        }
//    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
           willPresent notification: UNNotification,
           withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.identifier)
        let tap = Interaction()
        tap.add(identifier: response.notification.request.identifier)
        
        // MARK: should display activity page
        Badge.achieved(notificationID: response.notification.request.identifier)
        if response.notification.request.identifier == Notification.Activity.rawValue {
             let tabbarController = UIApplication.shared.windows.first?.rootViewController as! TabBarViewController
            tabbarController.selectedIndex = 2
            let nav = tabbarController.viewControllers![2] as! UINavigationController
            nav.viewControllers.first?.performSegue(withIdentifier: "history", sender:Any?.self)
        }
        completionHandler()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    //commented it because it causes exception in ipad and there is no use for it
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if CLLocationManager.locationServicesEnabled() {
//        switch status {
//            case .notDetermined, .restricted, .denied:
//                print("denied locatoin delegate")
//                appSettings.setNotification(option: Notification.Location.rawValue, value: false)
//            case .authorizedAlways, .authorizedWhenInUse:
//                appSettings.setNotification(option: Notification.Location.rawValue, value: true)
//                print("acceepted locatoin delegate")
//            @unknown default:
//                break
//            }
//        }
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            //print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
    }
    
        
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let LocalAppSettings = notificationSettings.getSettings()
        //let todayRoutine = dailyRoutine.getToday()
        let activityResult  = dailyRoutine.hasBeenActiveEnough()
        if  activityResult == "yes"{
            notificationSettings.cancelNotification(identifier: Notification.Activity.rawValue)
        }
        else{
            LocalAppSettings.setUpActivityNotification(activity: activityResult)
        }
            let sendAfter = LocalAppSettings.locationSendAfter
            let content = UNMutableNotificationContent()
            content.title = "Are you ready to do some exercises?"
            content.body = "Tap to start now."
            content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (TimeInterval(sendAfter)), repeats: false)

            let request = UNNotificationRequest(identifier: Notification.Location.rawValue, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
    }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
            notificationSettings.cancelNotification(identifier: Notification.Location.rawValue)
    }
}
