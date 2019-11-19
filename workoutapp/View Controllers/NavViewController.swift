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

class NavViewController: UINavigationController {
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    var timer: Timer!
    var user: UserModel!
    let realm = try! Realm()

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
        if ExerciseModel.loadExercises() == []{
            ExerciseModel.initExerciseModelTable(realm: realm)
        }
            
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
            print("has launched before")
            return false
        }
        else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return true
        }
    }
        
    
    func askName(){
            let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Awsome me"
            })

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                if let name = alert.textFields?.first?.text {
                    self.creatUser(name: name)
                    print("Your name: \(name)")
                }
            }))
            self.present(alert, animated: true, completion: nil)
         
    }
    
    func creatUser(name: String){
        try! realm.write {
          let newUser = UserModel()
            
          newUser.name = name
          realm.add(newUser)
          user = newUser
        }
        UserDefaults.standard.set(user.uuid, forKey: "uuid")
    }
    
    

}
