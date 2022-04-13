//
//  SettingsViewExt.swift
//  
//
//  Created by Negar on 2020-04-17.
//

import UIKit

enum Alert: String {
    case restDuration = "restDuration"
    case setAfter = "sendAfterTime"
    case setOn = "sendOnTime"
}

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func createRestDurationAlert() {
        restDurationAlert.addTextField(configurationHandler: { [weak self] textField in
            textField.inputView = self?.picker
        })
        
        restDurationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        restDurationAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            
            if let rd = strongSelf.restDurationAlert.textFields?.first?.text {
                let minutes = strongSelf.picker.selectedRow(inComponent: 0)
                let seconds = strongSelf.picker.selectedRow(inComponent: 1)
                strongSelf.user.setRestDuration(minutes * 60 + seconds)
                strongSelf.restLabel.text = rd
            }
        }))
        
    }
    
    func createSendAfterAlert() {
        sendAfterAlert.addTextField(configurationHandler: { [weak self] textField in
            guard let strongSelf = self else { return }
            
            strongSelf.textFieldTemp2 = textField
            strongSelf.countdownDatePicker.datePickerMode = .countDownTimer
            strongSelf.countdownDatePicker.addTarget(self, action: #selector(strongSelf.handleCountDownPicker(sender:)), for: .valueChanged)
            textField.inputView = self?.countdownDatePicker
            textField.text = MinutesToString(time: strongSelf.appSettings.locationSendAfter)
            strongSelf.countdownDatePicker.countDownDuration = TimeInterval(strongSelf.appSettings.locationSendAfter)
            
        })
        
        sendAfterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        sendAfterAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            
            if let rd = strongSelf.sendAfterAlert.textFields?.first?.text {
                strongSelf.appSettings.setSendAfter(value: Int(strongSelf.countdownDatePicker.countDownDuration))
                strongSelf.sendAfterTime.text = rd
            }
        }))
    }
    
    @IBAction func onSendOnTimePickerChange(_ sender: UIDatePicker) {
        appSettings.setTime(value: sender.date.getHourMinuteFormat())
        appSettings.setUpTimeNotification()
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
        let minutes = pickerView.selectedRow(inComponent: 0)
        let seconds = pickerView.selectedRow(inComponent: 1)
        restDurationAlert.textFields?.first?.text = SecondsToString(time: (minutes * 60) + seconds)
    }
}
