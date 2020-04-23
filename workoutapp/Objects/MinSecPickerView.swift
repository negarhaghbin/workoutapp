//
//  MinSecPickerView.swift
//  workoutapp
//
//  Created by Negar on 2020-04-22.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class MinSecPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    lazy var UIPicker: UIPickerView = {
        var pv: UIPickerView = UIPickerView()
        pv.tag = 9
        pv.delegate = self
        pv.dataSource = self
        return pv
    }()
    
    var value:String = ""
    
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
        value = SecondsToString(time: (pickerView.selectedRow(inComponent: 0))*60 + pickerView.selectedRow(inComponent: 1))
    }
    
    func addPickerLabels(){
        let font = UIFont.boldSystemFont(ofSize: 20.0)
        let fontSize: CGFloat = font.pointSize
        let componentWidth: CGFloat = self.frame.width / CGFloat(UIPicker.numberOfComponents)
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
    
    func getValue()->Int{
        return UIPicker.selectedRow(inComponent: 0)*60 + UIPicker.selectedRow(inComponent: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(UIPicker)
        UIPicker.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: UIPicker, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: UIPicker, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: UIPicker, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: UIPicker, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        addPickerLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
