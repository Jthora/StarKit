//
//  Date+Extension.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/7/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation


extension Date {
    
    // Daytime
    public var hour:Int {
        return Calendar.current.component(.hour, from: self)
    }
    public var minute:Int {
        return Calendar.current.component(.minute, from: self)
    }
    public var second:Int {
        return Calendar.current.component(.second, from: self)
    }
    public var fractionOfDay:Float {
        return (Float(hour) + (Float(minute)/60.0) + (Float(second)/3600.0)) / 24.0
    }
    
    //Yeartime
    public var daysThisYear:Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self) ?? 1
    }
    public var fractionOfYear:Float {
        return Float(daysThisYear) / 365.0
    }
    public var fractionAfterWinterSolstice:Float {
        return Float(daysThisYear+10).truncatingRemainder(dividingBy: 365) / 365.0
    }
    
    public func resetTime(timedate:Date) -> Date {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        var resultdate = Date()
        if let dateFromString = df.date(from: df.string(from: self)) {
            
            let hour = NSCalendar.current.component(.hour, from: timedate)
            let minutes = NSCalendar.current.component(.minute, from: timedate)
            if let dateFromStringWithTime = NSCalendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: dateFromString) {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS'Z"
                let resultString = df.string(from: dateFromStringWithTime)
                resultdate = df.date(from: resultString)!
            }
        }
        return resultdate
    }
    
}
