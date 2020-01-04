//
//  LocationNotificationScheduler.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import CoreLocation
import UserNotifications

class LocationNotificationScheduler: NSObject {
    func requestNotification(with frequentLocation: location, locationManager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                self.requestNotification(frequentLocation: frequentLocation)
            case .authorizedWhenInUse, .authorizedAlways:
                self.requestNotification(frequentLocation: frequentLocation)
            case .restricted, .denied:
                print ("location access denied")
                break
        }
    }
    
    private func requestNotification(frequentLocation: location) {
        print("hrer")
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            print(notificationRequests)
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == Notification.Location.rawValue {
                        return
                }
            }
        }
        let notification = UNMutableNotificationContent()
        notification.title = "Are you ready?"
        notification.body = "Tap."
        notification.sound = .default
        print("hrer2")
        let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: frequentLocation.latitude, longitude: frequentLocation.longitude),
                                          radius: 1.0,
                                          identifier: "home_location_id")
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: true)
        
        let request = UNNotificationRequest(identifier: Notification.Location.rawValue,
                                            content: notification,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
}
