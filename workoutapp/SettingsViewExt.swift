//
//  SettingsViewExt.swift
//  
//
//  Created by Negar on 2020-04-17.
//

import UIKit

enum Alert: String{
    case restDuration = "restDuration"
    case setAfter = "sendAfterTime"
    case setOn = "sendOnTime"
}

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func createRestDurationAlert(){
        restDurationAlert.addTextField(configurationHandler: { textField in
            textField.inputView = self.UIPicker
        })
        
        restDurationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        restDurationAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let rd = self.restDurationAlert.textFields?.first?.text {
                self.user.setRestDuration(rd: self.UIPicker.selectedRow(inComponent: 0)*60 + self.UIPicker.selectedRow(inComponent: 1))
                self.restLabel.text = rd
            }
        }))
        
    }
    
    func createSendAfterAlert(){
        sendAfterAlert.addTextField(configurationHandler: { textField in
            self.textFieldTemp2 = textField
            self.countdownDatePicker.datePickerMode = .countDownTimer
            self.countdownDatePicker.addTarget(self, action: #selector(self.handleCountDownPicker(sender:)), for: .valueChanged)
            textField.inputView = self.countdownDatePicker
            textField.text = MinutesToString(time: self.appSettings.locationSendAfter)
            self.countdownDatePicker.countDownDuration = TimeInterval(self.appSettings.locationSendAfter)
            
        })
        
        sendAfterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        sendAfterAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let rd = self.sendAfterAlert.textFields?.first?.text {
                self.appSettings.setSendAfter(value: Int(self.countdownDatePicker.countDownDuration))
                self.sendAfterTime.text = rd
            }
        }))
    }
    
    func createSendOnAlert(){
        sendOnAlert.addTextField(configurationHandler: { textField in
            self.textFieldTemp = textField
            self.datePicker.datePickerMode = .time
            self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
            textField.inputView = self.datePicker
            textField.text = self.appSettings.time
            
        })
        
        sendOnAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        sendOnAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let rd = self.sendOnAlert.textFields?.first?.text {
                self.appSettings.setTime(value: self.textFieldTemp.text!)
                self.appSettings.setUpTimeNotification()
                self.timeLabel.text = rd
            }
        }))
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        datePicker.date = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        textFieldTemp.text = dateFormatter.string(from: sender.date)
    }
       
    @objc func handleCountDownPicker(sender: UIDatePicker) {
        countdownDatePicker.countDownDuration = sender.countDownDuration
        textFieldTemp2.text = MinutesToString(time: Int(sender.countDownDuration))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        restDurationAlert.textFields?.first?.text = SecondsToString(time: (pickerView.selectedRow(inComponent: 0))*60 + pickerView.selectedRow(inComponent: 1))
    }
    
    
    
}
