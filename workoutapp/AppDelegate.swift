//
//  AppDelegate.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("here here here")
        if ExerciseModel.loadExercises() == []{
            ExerciseModel.initExerciseModelTable()
        }
        
        try? AVAudioSession.sharedInstance().setCategory( AVAudioSession.Category.ambient, mode: AVAudioSession.Mode.moviePlayback, options: [.mixWithOthers])
        


        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        //OneSignal.initWithLaunchOptions(launchOptions, appId: "49bbdbe3-71f3-418e-a5ad-9268e1826031", handleNotificationAction: nil, settings: onesignalInitSettings)

        //OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        //OneSignal.promptLocation()
        //OneSignal.promptForPushNotifications(userResponse: { accepted in
        //print("User accepted notifications: \(accepted)")
        //})
        //registerForPushNotifications()
        
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
        print("here")
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
          print("Permission granted: \(granted)")
          guard granted else { return }
          self?.getNotificationSettings()
      }
    }


    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }

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
    

}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void) {
//
//    // 1
//    let userInfo = response.notification.request.content.userInfo
//
//    // 2
//    if let aps = userInfo["aps"] as? [String: AnyObject],
//      let newsItem = NewsItem.makeNewsItem(aps) {
//
//      (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//
//      // 3
//      if response.actionIdentifier == Identifiers.viewAction,
//        let url = URL(string: newsItem.link) {
//        let safari = SFSafariViewController(url: url)
//        window?.rootViewController?.present(safari, animated: true,
//                                            completion: nil)
//      }
//    }
//
//    // 4
//    completionHandler()
//  }
//}


