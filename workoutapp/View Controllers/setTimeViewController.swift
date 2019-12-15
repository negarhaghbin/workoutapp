//
//  setTimeViewController.swift
//  workoutapp
//
//  Created by Negar on 2019-12-15.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class setTimeViewController: UITableViewController {
    let setting = try! Realm().objects(notificationSettings.self).first!

    @IBOutlet weak var timefield: UITextField!
    private var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)

        timefield.inputView = datePicker
        timefield.text = setting.time
    }
    
    @IBAction func changeTime(_ sender: Any) {
        setting.setTime(value: timefield.text!)
         _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timefield.text = dateFormatter.string(from: sender.date)
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
