//
//  SettingsTableViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-11-08.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import CoreLocation

enum Notification: String {
    case Activity = "activity"
    case Location = "location"
    case Time = "time"
}

class SettingsTableViewController: UITableViewController, CLLocationManagerDelegate{
    
    // MARK: - Outlets
    
    @IBOutlet weak var sendAfterTime: UILabel!
    @IBOutlet weak var sendAfterTitleLabel: UILabel!
    @IBOutlet weak var sendOnTitleLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var sendAfterCell: UITableViewCell!
    @IBOutlet weak var setTimeCell: UITableViewCell!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var sendOnTimePicker: UIDatePicker!
    @IBOutlet weak var userName: UILabel!
    
    // MARK: - Variables
    
    let locationManager = CLLocationManager()
    var textFieldTemp2: UITextField = UITextField()
    var restDurationAlert = UIAlertController(title: "Set rest time", message: nil, preferredStyle: .alert)
    var sendAfterAlert = UIAlertController(title: "Send reminders", message: "Send reminder notifications based on my location after: ", preferredStyle: .alert)

    var picker: UIPickerView = UIPickerView()
    var datePicker: UIDatePicker = UIDatePicker()
    var countdownDatePicker: UIDatePicker = UIDatePicker()
    
    private enum Sections: Int {
        case rest = 1
        case location = 3
        case time = 4
    }
    
    var user: User = User()
    var appSettings: notificationSettings = notificationSettings()
    
    var notifAuthorized: Bool = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        addPickerLabels(picker: picker, vc: self)
        createRestDurationAlert()
        createSendAfterAlert()
        user = RealmManager.getUser()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(viewWillAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        userName.text = user.name
        restLabel.text = secondsToMSString(time: user.restDuration)
        checkNotificationAuthorization(completion:{ authorization in
            DispatchQueue.main.async { [weak self] in
                self?.refreshUI(authorization: authorization)
            }
            
        })
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - TableViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == Sections.rest.rawValue && indexPath.row == 0 {
            present(restDurationAlert, animated: true)
        } else if indexPath.section == Sections.location.rawValue && indexPath.row == 1 {
            present(sendAfterAlert, animated: true)
        }
    }
    
    // MARK: - Helpers
    
    private func locationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                self.appSettings.setNotification(option: Notification.Location.rawValue, value: true)
            case .restricted, .denied, .notDetermined:
                self.appSettings.setNotification(option: Notification.Location.rawValue, value: false)
                break
        }
    }
    
    private func enableDisableLocationNotification(isEnabled: Bool) {
        if isEnabled {
            self.locationAuthorization()
        }
        
        sendAfterTime.isEnabled = isEnabled
        sendAfterTitleLabel.isEnabled = isEnabled
        sendAfterCell.isUserInteractionEnabled = isEnabled
    }
    
    private func enableDisableTimeNotification(isEnabled: Bool) {
        sendOnTimePicker.isEnabled = isEnabled
        sendOnTitleLabel.isEnabled = isEnabled
        setTimeCell.isUserInteractionEnabled = isEnabled
    }
    
    private func setupUIForNotificationAuthorization(isAuthorized: Bool) {
        timeSwitch.setOn(isAuthorized, animated: false)
        locationSwitch.setOn(isAuthorized, animated: false)
        sendAfterTime.isEnabled = isAuthorized
        sendAfterTitleLabel.isEnabled = isAuthorized
        sendAfterCell.isUserInteractionEnabled = isAuthorized
        activitySwitch.setOn(isAuthorized, animated: false)
        
        sendOnTimePicker.isEnabled = isAuthorized
        sendOnTitleLabel.isEnabled = isAuthorized
        setTimeCell.isUserInteractionEnabled = isAuthorized
    }
    
    private func refreshUI(authorization: Bool) {
        appSettings = RealmManager.getAppSettings()
        sendAfterTime.text = secondsToHMString(time: appSettings.locationSendAfter)
        let time = Date.getTimeFromString(appSettings.time)
        if let date = Calendar.current.date(bySettingHour: time.h, minute: time.m, second: 0, of: Date()) {
            sendOnTimePicker.date = date
        }
        
        textFieldTemp2.text = secondsToHMString(time: self.appSettings.locationSendAfter)
        if authorization {
            timeSwitch.setOn(self.appSettings.timeBool, animated: false)
            locationSwitch.setOn(self.appSettings.location, animated: false)
            enableDisableLocationNotification(isEnabled: locationSwitch.isOn)
            activitySwitch.setOn(self.appSettings.activity, animated: false)
            enableDisableTimeNotification(isEnabled: timeSwitch.isOn)
        } else {
            setupUIForNotificationAuthorization(isAuthorized: false)
        }
        
        self.notifAuthorized = authorization
    }
    
    @objc func checkNotificationAuthorization(completion: @escaping(Bool) -> Void) {
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
    
    private func setTimeSettings(value: Bool) {
        appSettings.setNotification(option: Notification.Time.rawValue, value: value)
        enableDisableTimeNotification(isEnabled: value)
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
    
    // MARK: - Actions

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if !notifAuthorized {
            presentSettingsAlert(option: "Notifications")
            setupUIForNotificationAuthorization(isAuthorized: false)
        } else {
            switch sender.restorationIdentifier {
            case Notification.Activity.rawValue:
                if(sender.isOn) {
                    appSettings.setNotification(option: Notification.Activity.rawValue, value: true)
                    appSettings.setUpActivityNotification(activity: "")
                } else {
                    appSettings.setNotification(option: Notification.Activity.rawValue, value: false)
                    notificationSettings.cancelNotification(identifier: Notification.Activity.rawValue)
                }
                
            case Notification.Location.rawValue:
                if(sender.isOn) {
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
                            enableDisableLocationNotification(isEnabled: false)
                            break
                    }
                    
                } else {
                    appSettings.setNotification(option: Notification.Location.rawValue, value: false)
                    enableDisableLocationNotification(isEnabled: false)
                    notificationSettings.cancelNotification(identifier: Notification.Location.rawValue)
                    let l = location.getMostRecordedLocation()
                    let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude),
                    radius: 1.0,
                    identifier: "home_location_id")
                    AppDelegate.locationManager.stopMonitoring(for: destRegion)
                }
                
            case Notification.Time.rawValue:
                if(sender.isOn) {
                    appSettings.setUpTimeNotification()
                    setTimeSettings(value: true)
                } else {
                    notificationSettings.cancelNotification(identifier: Notification.Time.rawValue)
                    setTimeSettings(value: false)
                }
            default:
                print("something has changed")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.edit {
            let vc = segue.destination as! NameTableViewController
            vc.user = user
        }
    }
}
