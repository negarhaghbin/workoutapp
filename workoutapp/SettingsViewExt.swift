//
//  SettingsViewExt.swift
//  
//
//  Created by Negar on 2020-04-17.
//

import UIKit

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func addPickerLabels(){
        let font = UIFont.boldSystemFont(ofSize: 20.0)
        let fontSize: CGFloat = font.pointSize
        let componentWidth: CGFloat = self.view.frame.width / CGFloat(UIPicker.numberOfComponents)
        let y = (UIPicker.frame.size.height / 2) - (fontSize / 2)

        let label1 = UILabel(frame: CGRect(x: componentWidth * 0.65, y: y, width: componentWidth * 0.4, height: fontSize))
        label1.font = font
        label1.textAlignment = .left
        label1.text = "min"
        UIPicker.addSubview(label1)

        let label2 = UILabel(frame: CGRect(x: componentWidth * 1.65, y: y, width: componentWidth * 0.4, height: fontSize))
        label2.font = font
        label2.textAlignment = .left
        label2.text = "sec"
        UIPicker.addSubview(label2)
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
        alert.textFields?.first?.text = SecondsToString(time: (pickerView.selectedRow(inComponent: 0))*60 + pickerView.selectedRow(inComponent: 1))
    }
    
    
    
}
