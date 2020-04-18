//
//  AppUtility.swift
//  workoutapp
//
//  Created by Negar on 2020-04-17.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

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
        if minutes == 1{
            return "\(hours) hour and \(minutes) minute"
        }
        else{
            return "\(hours) hour and \(minutes) minutes"
        }
    default:
        return "\(hours) hours and \(minutes) minutes"
    }
}

func SecondsToString(time: Int)->String{
    let minutes = time / 60
    let seconds = time % 60
    print(minutes)
    print(seconds)
    switch minutes {
    case 0:
        if seconds == 1{
            return "\(seconds) second"
        }
        else{
            return "\(seconds) seconds"
        }
    case 1:
        if seconds == 1{
            return "\(minutes) minute and \(seconds) second"
        }
        else{
            return "\(minutes) minute and \(seconds) seconds"
        }
    default:
        return "\(minutes) minutes and \(seconds) seconds"
    }
}
