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
        Step.askAuthorization {
            Step.update()
        }
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
            guard let strongSelf = self else { return }
            
            if strongSelf.isNewUser() {
                strongSelf.appSettings = notificationSettings.addNewSettings(granted: granted)
                if granted {
                    strongSelf.appSettings.setUpTimeNotification()
                    strongSelf.appSettings.setUpActivityNotification(activity: "")
                }
            } else {
                strongSelf.appSettings = notificationSettings.getSettings()
                if strongSelf.appSettings.timeBool {
                    strongSelf.appSettings.setUpTimeNotification()
                }
                if strongSelf.appSettings.activity {
                    strongSelf.appSettings.setUpActivityNotification(activity: "")
                }
            }
            if granted {
                strongSelf.addNotificationCategories()
                OperationQueue.main.addOperation {
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
            
            strongSelf.center.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func addNotificationCategories(){
        let notTodayAction = UNNotificationAction(identifier: NotificationActionID.notToday.rawValue,
                                                  title: "Not feeling it today",
                                                  options: UNNotificationActionOptions(rawValue: 0))
        
        let snoozeAction = UNNotificationAction(identifier: NotificationActionID.snooze.rawValue,
                                                title: "Remind me in 1 hour",
                                                options: UNNotificationActionOptions(rawValue: 0))
        
        let snoozableCategory =
              UNNotificationCategory(identifier: NotificationCategoryID.snoozable.rawValue,
              actions: [notTodayAction, snoozeAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        center.setNotificationCategories([snoozableCategory])
        
    }
    
    func isNewUser() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return false
        } else {
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
        let LocalAppSettings = notificationSettings.getSettings()
        
        let ACTIVITY_TAB_INDEX = 2
        
        let notificationID = response.notification.request.identifier
        let interaction = Interaction(identifier: notificationID)
        interaction.add()
        
        Badge.achieved(notificationID: notificationID)
        
        
        let storyboard = UIStoryboard(name: "NotificationLaunch", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "NotificationStoryboard") as? NotificationLauncherViewController {
            vc.interaction = interaction
            if notificationID == Notification.Activity.rawValue {
                vc.nextViewControllerTabIndex = ACTIVITY_TAB_INDEX
            }
            
            UIApplication.shared.windows.first?.rootViewController = vc
        }
        
        switch response.actionIdentifier {
        case NotificationActionID.notToday.rawValue:
            LocalAppSettings.setNotFeelingItOn(date: Date())
            center.removeAllPendingNotificationRequests()
            break
               
        case NotificationActionID.snooze.rawValue:
            notificationSettings.setupSnoozedNotification()
            break
            
        default:
            break
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
//            print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
    }
    
        
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let LocalAppSettings = notificationSettings.getSettings()
        if !LocalAppSettings.doesFeelingItOn(date: Date()) {
            return
        }
        if  DiaryItem.hasBeenActiveEnoughInTotal() {
            notificationSettings.cancelNotification(identifier: Notification.Activity.rawValue)
        } else {
            for type in [ExerciseType.total.rawValue, ExerciseType.abs.rawValue, ExerciseType.lower.rawValue, ExerciseType.upper.rawValue] {
                if !DiaryItem.hasBeenActiveEnough(In: type) {
                    LocalAppSettings.setUpActivityNotification(activity: type)
                    break
                }
            }
        }
        
        let sendAfter = LocalAppSettings.locationSendAfter
        let content = UNMutableNotificationContent()
        content.title = "Are you ready to do some exercises?"
        content.body = "Tap to start now."
        content.sound = .default
        content.categoryIdentifier = NotificationCategoryID.snoozable.rawValue
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (TimeInterval(sendAfter)), repeats: false)
        
        let request = UNNotificationRequest(identifier: Notification.Location.rawValue, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
            notificationSettings.cancelNotification(identifier: Notification.Location.rawValue)
    }
}
