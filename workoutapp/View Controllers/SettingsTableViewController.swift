//
//  SettingsTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-08.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

enum Notification: String {
    case Activity = "activity"
    case Location = "location"
    case Time = "time"
}

class SettingsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var textFieldTemp : UITextField = UITextField()
    var textFieldTemp2 : UITextField = UITextField()
    var restDurationAlert = UIAlertController(title: "Set rest time", message: nil, preferredStyle: .alert)
    var sendAfterAlert = UIAlertController(title: "Send reminders", message: "Send reminder notifications based on my location after: ", preferredStyle: .alert)
    var sendOnAlert = UIAlertController(title: "Send reminders", message: "Send reminder notifications daily on: ", preferredStyle: .alert)
    var UIPicker: UIPickerView = UIPickerView()
    var datePicker: UIDatePicker = UIDatePicker()
    var countdownDatePicker : UIDatePicker = UIDatePicker()
    
    
    var user : User = User()
    var appSettings : notificationSettings = notificationSettings()
    @IBOutlet weak var sendAfterTime: UILabel!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var sendAfterTitleLabel: UILabel!
    @IBOutlet weak var sendOnTitleLabel: UILabel!
    
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var sendAfterCell: UITableViewCell!
    @IBOutlet weak var setTimeCell: UITableViewCell!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var notifAuthorized : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIPicker.delegate = self
        UIPicker.dataSource = self
        addPickerLabels(picker: UIPicker, vc: self)
        createRestDurationAlert()
        createSendOnAlert()
        createSendAfterAlert()
        user = try! Realm().object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(viewWillAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        userName.text = user.name
        restLabel.text = SecondsToString(time: user.restDuration)
        checkNotificationAuthorization(completion:{ authorization in
            DispatchQueue.main.async {
                self.refreshUI(authorization: authorization)
            }
            
        })
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    private func locationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                self.appSettings.setNotification(option: Notification.Location.rawValue, value: true)
            case .restricted, .denied, .notDetermined:
                self.appSettings.setNotification(option: Notification.Location.rawValue, value: false)
                break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let LOCATION_SECTION = 3
        let TIME_SECTION = 4
        if indexPath.section == 1 && indexPath.row == 0{
            present(restDurationAlert, animated: true)
        }
        else if indexPath.section == LOCATION_SECTION && indexPath.row == 1{
            present(sendAfterAlert, animated: true)
        }
        else if indexPath.section == TIME_SECTION && indexPath.row == 1{
            present(sendOnAlert, animated: true)
        }
    }
    
    private func refreshUI(authorization: Bool){
        appSettings = try! Realm().objects(notificationSettings.self).first!
        sendAfterTime.text =
            MinutesToString(time: appSettings.locationSendAfter)
        timeLabel.text = appSettings.time
        textFieldTemp2.text = MinutesToString(time: self.appSettings.locationSendAfter)
        textFieldTemp.text = self.appSettings.time
        if authorization{
            self.timeSwitch.setOn(self.appSettings.timeBool, animated: false)
            self.locationSwitch.setOn(self.appSettings.location, animated: false)
            if self.locationSwitch.isOn{
                self.locationAuthorization()
                self.sendAfterTime.isEnabled = true
                self.sendAfterTitleLabel.isEnabled = true
                self.sendAfterCell.isUserInteractionEnabled = true
            }
            else{
                self.sendAfterTime.isEnabled = false
                self.sendAfterTitleLabel.isEnabled = false
                self.sendAfterCell.isUserInteractionEnabled = false
            }
            self.activitySwitch.setOn(self.appSettings.activity, animated: false)
            if(self.timeSwitch.isOn){
                self.timeLabel.isEnabled = true
                self.sendOnTitleLabel.isEnabled = true
                self.setTimeCell.isUserInteractionEnabled = true
            }
            else{
                self.timeLabel.isEnabled = false
                self.sendOnTitleLabel.isEnabled = false
                self.setTimeCell.isUserInteractionEnabled = false
            }
        }
        else{
            self.timeSwitch.setOn(false, animated: false)
            self.locationSwitch.setOn(false, animated: false)
            self.sendAfterTime.isEnabled = false
            self.sendAfterTitleLabel.isEnabled = false
            self.sendAfterCell.isUserInteractionEnabled = false
            self.activitySwitch.setOn(false, animated: false)
            self.timeLabel.isEnabled = false
            self.sendOnTitleLabel.isEnabled = false
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

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if !notifAuthorized{
            presentSettingsAlert(option: "Notifications")
            self.timeSwitch.setOn(false, animated: false)
            self.locationSwitch.setOn(false, animated: false)
            self.sendAfterTime.isEnabled = false
            self.sendAfterTitleLabel.isEnabled = false
            self.sendAfterCell.isUserInteractionEnabled = false
            self.activitySwitch.setOn(false, animated: false)
            self.timeLabel.isEnabled = false
            self.sendOnTitleLabel.isEnabled = false
            self.setTimeCell.isUserInteractionEnabled = false
        }
        else{
            switch sender.restorationIdentifier {
            case Notification.Activity.rawValue:
                if(sender.isOn){
                    appSettings.setNotification(option: Notification.Activity.rawValue, value: true)
                    appSettings.setUpActivityNotification(activity: "")
                }
                else{
                    appSettings.setNotification(option: Notification.Activity.rawValue, value: false)
                    notificationSettings.cancelNotification(identifier: Notification.Activity.rawValue)
                }
                
            case Notification.Location.rawValue:
                if(sender.isOn){
                    switch CLLocationManager.authorizationStatus() {
                        case .authorizedWhenInUse, .authorizedAlways:
                            appSettings.setNotification(option: Notification.Location.rawValue, value: true)
                            locationManager.delegate = self
                            locationManager.desiredAccuracy = kCLLocationAccuracyBest
                            locationManager.startUpdatingLocation()
                            let l = location.getMostRecordedLocation()
                            let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude),
                            radius: 1.0,
                            identifier: "home_location_id")
                            AppDelegate.locationManager.startMonitoring(for: destRegion)
                            self.sendAfterTime.isEnabled = true
                            self.sendAfterTitleLabel.isEnabled = true
                            self.sendAfterCell.isUserInteractionEnabled = true
                        case .restricted, .denied, .notDetermined:
                            presentSettingsAlert(option: "Location")
                            self.locationSwitch.setOn(false, animated: false)
                            self.sendAfterTime.isEnabled = false
                            self.sendAfterTitleLabel.isEnabled = false
                            self.sendAfterCell.isUserInteractionEnabled = false
                            break
                    }
                    
                }
                else{
                    appSettings.setNotification(option: Notification.Location.rawValue, value: false)
                    self.sendAfterTime.isEnabled = false
                    self.sendAfterTitleLabel.isEnabled = false
                    self.sendAfterCell.isUserInteractionEnabled = false
                    notificationSettings.cancelNotification(identifier: Notification.Location.rawValue)
                    let l = location.getMostRecordedLocation()
                    let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude),
                    radius: 1.0,
                    identifier: "home_location_id")
                    AppDelegate.locationManager.stopMonitoring(for: destRegion)
                }
                
            case Notification.Time.rawValue:
                if(sender.isOn){
                    appSettings.setUpTimeNotification()
                    setTimeSettings(value: true)
                    
                }
                else{
                    notificationSettings.cancelNotification(identifier: Notification.Time.rawValue)
                    setTimeSettings(value: false)
                }
            default:
                print("something has changed")
            }
        }
    }
    
    private func setTimeSettings(value: Bool){
        appSettings.setNotification(option: Notification.Time.rawValue, value: value)
        timeLabel.isEnabled = value
        sendOnTitleLabel.isEnabled = value
        setTimeCell.isUserInteractionEnabled = value
    }
    
    private func presentSettingsAlert(option: String) {
        let alertController = UIAlertController(title: "\(option) are disabled",
                                                message: "You need to enable it from settings first.",
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
        if segue.identifier == "edit" {
            let vc = segue.destination as! NameTableViewController
            vc.user = user
        }
        
    }
    

}
