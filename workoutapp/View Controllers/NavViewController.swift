//
//  NavViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-09-21.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import CoreMotion
import RealmSwift
import CoreLocation

class NavViewController: UINavigationController {
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    var timer: Timer!
    
    var user: User!
    let realm = try! Realm()
    var todayRoutine : dailyRoutine = dailyRoutine()
    
    private let locationNotificationScheduler = LocationNotificationScheduler()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
//        motionManager.startAccelerometerUpdates()
//        motionManager.startGyroUpdates()
//        motionManager.startMagnetometerUpdates()
//        motionManager.startDeviceMotionUpdates()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(NavViewController.update), userInfo: nil, repeats: true)
        
        if isNewUser(){
            askName()
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
        if(CLLocationManager.locationServicesEnabled()){
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    presentSettingsAlert()
                case .authorizedAlways, .authorizedWhenInUse:
                    let l = location.getMostRecordedLocation()
                    self.scheduleLocationNotification(frequentLocation: l)
                @unknown default:
                break
            }
            
        }
            
    }
    
    func scheduleLocationNotification(frequentLocation: location) {
        print("fer: \(frequentLocation)")
        let notificationInfo = LocationNotificationInfo(notificationId: "home_notification_id",
                                                        locationId: "home_location_id",
                                                        radius: 1.0,
                                                        latitude: frequentLocation.latitude,
                                                        longitude: frequentLocation.longitude,
                                                        title: "Are you ready to do your exercises?",
                                                        body: "Tap to start now.",
                                                        data: [:])
        
        locationNotificationScheduler.requestNotification(with: notificationInfo, locationManager: locationManager)
        
    }
    
    private func startTrackingActivityType() {
      
    }
    
    @objc func update(){
            activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in

            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    print("Walking")
                } else if activity.stationary {
                    print("Stationary")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
//        if let accelerometerData = motionManager.accelerometerData {
//            print(accelerometerData)
//        }
//        if let gyroData = motionManager.gyroData {
//            print(gyroData)
//        }
//        if let magnetometerData = motionManager.magnetometerData {
//            print(magnetometerData)
//        }
//        if let deviceMotion = motionManager.deviceMotion {
//            print(deviceMotion)
//        }
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
        
    
    func askName(){
            let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.creatUser(name: "Awsome me")
            }))

            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Awsome me"
            })

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                if let name = alert.textFields?.first?.text {
                    self.creatUser(name: name)
                }
            }))
            self.present(alert, animated: true, completion: nil)
         
    }
    
    func creatUser(name: String){
        let newUser = User()
        let settings = notificationSettings()
        newUser.name = name
        
        try! realm.write {
            realm.add(newUser)
            realm.add(settings)
        }
        
        user = newUser
        
        UserDefaults.standard.set(user.uuid, forKey: "uuid")
    }
    
    

}

extension NavViewController {
    private func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    private func presentSettingsAlert() {
        let alertController = UIAlertController(title: "",
                                                message: "You can always enable notifications from settings.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}


extension NavViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
    }
}
