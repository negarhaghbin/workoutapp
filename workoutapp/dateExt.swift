//
//  dateExt.swift
//  workoutapp
//
//  Created by Negar on 2020-01-06.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func makeDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self)
    }
    
    func makeDateTimeString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: self)
    }
    
    func getWholeDate() -> (startDate:Date, endDate: Date) {
        var startDate = self
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate,endDate)
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func getHourMinuteFormat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    static func getTimeFromString(_ time: String)->(h: Int, m:Int){
        var index = time.firstIndex(of: ":")!
        let hour = time[..<index]
        index = time.index(after: index)
        let minute = time[index...]
        
        return (h: Int(hour)!, m:Int(minute)!)
    }
}
