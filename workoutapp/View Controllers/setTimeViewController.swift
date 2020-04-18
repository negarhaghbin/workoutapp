//
//  setTimeViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-12-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

enum SegueId: String {
    case setAfter = "sendAfterTime"
    case setOn = "sendOnTime"
}

class setTimeViewController: UITableViewController {
    let setting = try! Realm().objects(notificationSettings.self).first!
    var identifier = ""
    @IBOutlet weak var timefield: UITextField!
    private var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(identifier)
        timefield.inputView = datePicker
        if identifier == SegueId.setAfter.rawValue{
            datePicker.datePickerMode = .countDownTimer
            datePicker.addTarget(self, action: #selector(handleCountDownPicker(sender:)), for: .valueChanged)
            timefield.text = MinutesToString(time: setting.locationSendAfter)
            datePicker.countDownDuration = TimeInterval(setting.locationSendAfter)
        }
        else{
            datePicker.datePickerMode = .time
            datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            timefield.text = setting.time
        }
        
    }
    
    @IBAction func changeTime(_ sender: Any) {
        if identifier == SegueId.setAfter.rawValue{
            setting.setSendAfter(value: Int(datePicker.countDownDuration))
        }
        else{
            setting.setTime(value: timefield.text!)
            setting.setUpTimeNotification()
        }

         _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        datePicker.date = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timefield.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleCountDownPicker(sender: UIDatePicker) {
        datePicker.countDownDuration = sender.countDownDuration
        timefield.text = MinutesToString(time: Int(datePicker.countDownDuration)) 
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
