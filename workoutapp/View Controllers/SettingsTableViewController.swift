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
    
    var settings : notificationSettings = notificationSettings()
    
    
    @IBOutlet weak var setTimeCell: UITableViewCell!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        user = try! Realm().object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
        settings = try! Realm().objects(notificationSettings.self).first!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        userName.text = user.name
        timeLabel.text = settings.getTime()
        timeSwitch.setOn(settings.timeBool, animated: false)
        locationSwitch.setOn(settings.location, animated: false)
        activitySwitch.setOn(settings.activity, animated: false)
        
        if(timeSwitch.isOn){
            timeLabel.isEnabled = true
            setTimeCell.isUserInteractionEnabled = true
        }
        else{
            timeLabel.isEnabled = false
            setTimeCell.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switch sender.restorationIdentifier {
        case Notification.Activity.rawValue:
            if(sender.isOn){
                settings.setActivity(value: true)
            }
            else{
                settings.setActivity(value: false)
                settings.disableNotification(identifier: Notification.Activity.rawValue)
            }
        case Notification.Location.rawValue:
            if(sender.isOn){
                settings.setLocation(value: true)
            }
            else{
                settings.setLocation(value: false)
                settings.disableNotification(identifier: Notification.Location.rawValue)
            }
        case Notification.Time.rawValue:
            if(sender.isOn){
                settings.setTime(value: true)
                settings.setUpTimeNotification()
                timeLabel.isEnabled = true
                setTimeCell.isUserInteractionEnabled = true
            }
            else{
                settings.setTime(value: false)
                settings.disableNotification(identifier: Notification.Time.rawValue)
                timeLabel.isEnabled = false
                setTimeCell.isUserInteractionEnabled = false
            }
        default:
            print("something has changed")
        }
        
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
