//
//  SettingsTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-08.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

enum Notification: String {
    case Activity = "activity"
    case Location = "location"
    case Time = "time"
}

class SettingsTableViewController: UITableViewController {
    var user : User = User()
    var appSettings : notificationSettings = notificationSettings()
    
    
    @IBOutlet weak var setTimeCell: UITableViewCell!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var notifAuthorized : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = try! Realm().object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
        //appSettings = try! Realm().objects(notificationSettings.self).first!
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(viewWillAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        userName.text = user.name
        checkNotificationAuthorization(completion:{ authorization in
            DispatchQueue.main.async {
                self.refreshUI(authorization: authorization)
            }
            
        })
    }
    
    private func refreshUI(authorization: Bool){
        self.appSettings = try! Realm().objects(notificationSettings.self).first!
        self.timeLabel.text = self.appSettings.getTime()
        if authorization{
            self.timeSwitch.setOn(self.appSettings.timeBool, animated: false)
            self.locationSwitch.setOn(self.appSettings.location, animated: false)
            self.activitySwitch.setOn(self.appSettings.activity, animated: false)
            if(self.timeSwitch.isOn){
                self.timeLabel.isEnabled = true
                self.setTimeCell.isUserInteractionEnabled = true
            }
            else{
                self.timeLabel.isEnabled = false
                self.setTimeCell.isUserInteractionEnabled = false
            }
        }
        else{
            self.timeSwitch.setOn(false, animated: false)
            self.locationSwitch.setOn(false, animated: false)
            self.activitySwitch.setOn(false, animated: false)
            self.timeLabel.isEnabled = false
            self.setTimeCell.isUserInteractionEnabled = false
        }
        
        self.notifAuthorized = authorization
    }
    
    @objc func checkNotificationAuthorization(completion: @escaping(Bool) -> Void){
        var authorization = false
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .denied {
                authorization=false
            } else if settings.authorizationStatus == .authorized {
                authorization=true
            }
            completion(authorization)
        })
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if !notifAuthorized{
            presentSettingsAlert()
            self.timeSwitch.setOn(false, animated: false)
            self.locationSwitch.setOn(false, animated: false)
            self.activitySwitch.setOn(false, animated: false)
            self.timeLabel.isEnabled = false
            self.setTimeCell.isUserInteractionEnabled = false
        }
        else{
            switch sender.restorationIdentifier {
            case Notification.Activity.rawValue:
                if(sender.isOn){
                    appSettings.setActivity(value: true)
                    appSettings.setUpActivityNotification()
                }
                else{
                    appSettings.setActivity(value: false)
                    appSettings.disableNotification(identifier: Notification.Activity.rawValue)
                }
            case Notification.Location.rawValue:
                if(sender.isOn){
                    appSettings.setLocation(value: true)
                }
                else{
                    appSettings.setLocation(value: false)
                    appSettings.disableNotification(identifier: Notification.Location.rawValue)
                }
            case Notification.Time.rawValue:
                if(sender.isOn){
                    appSettings.setTime(value: true)
                    appSettings.setUpTimeNotification()
                    timeLabel.isEnabled = true
                    setTimeCell.isUserInteractionEnabled = true
                }
                else{
                    appSettings.setTime(value: false)
                    appSettings.disableNotification(identifier: Notification.Time.rawValue)
                    timeLabel.isEnabled = false
                    setTimeCell.isUserInteractionEnabled = false
                }
            default:
                print("something has changed")
            }
        }
    }
    
    private func presentSettingsAlert() {
        let alertController = UIAlertController(title: "Notifications are disabled",
                                                message: "You need to enable notifications from settings first.",
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        if segue.identifier == "edit" {
            let vc = segue.destination as! NameTableViewController
            vc.user = user
        }
        
        // Pass the selected object to the new view controller.
    }
    

}
