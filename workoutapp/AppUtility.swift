//
//  AppUtility.swift
//  workoutapp
//
//  Created by Negar on 2020-04-17.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import UIKit

func MinutesToString(time: Int)->String{
    //print(time)
    let hours = time / 3600
    let minutes = time / 60 % 60
    switch hours {
    case 0:
        if minutes == 1{
            return "\(minutes) minute"
        }
        else{
            return "\(minutes) minutes"
        }
    case 1:
        if minutes == 0{
            return "\(hours) hour"
        }
        else if minutes == 1{
            return "\(hours) hour and \(minutes) minute"
        }
        else{
            return "\(hours) hour and \(minutes) minutes"
        }
    default:
        if minutes == 0{
            return "\(hours) hours"
        }
        else if minutes == 1{
            return "\(hours) hours and \(minutes) minute"
        }
        else{
            return "\(hours) hours and \(minutes) minutes"
        }
    }
}

func SecondsToString(time: Int)->String{
    let minutes = time / 60
    let seconds = time % 60
    switch minutes {
    case 0:
        if seconds == 1{
            return "\(seconds) second"
        }
        else{
            return "\(seconds) seconds"
        }
    case 1:
        if seconds == 0{
            return "\(minutes) minute"
        }
        else if seconds == 1{
            return "\(minutes) minute and \(seconds) second"
        }
        else{
            return "\(minutes) minute and \(seconds) seconds"
        }
    default:
        if seconds == 0{
            return "\(minutes) minutes"
        }
        else if seconds == 1{
            return "\(minutes) minutes and \(seconds) second"
        }
        else{
            return "\(minutes) minutes and \(seconds) seconds"
        }
    }
}

func addPickerLabels(picker: UIPickerView, vc: UIViewController){
    let font = UIFont.boldSystemFont(ofSize: 20.0)
    let fontSize: CGFloat = font.pointSize
    let componentWidth: CGFloat = vc.view.frame.width / CGFloat(picker.numberOfComponents)
    let y = (picker.frame.size.height / 2) - (fontSize / 2)

    let label1 = UILabel(frame: CGRect(x: componentWidth * 0.65, y: y, width: componentWidth * 0.4, height: fontSize))
    label1.font = font
    label1.textAlignment = .left
    label1.text = "min"
    picker.addSubview(label1)

    let label2 = UILabel(frame: CGRect(x: componentWidth * 1.65, y: y, width: componentWidth * 0.4, height: fontSize))
    label2.font = font
    label2.textAlignment = .left
    label2.text = "sec"
    picker.addSubview(label2)
}
