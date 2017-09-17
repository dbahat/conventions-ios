//
//  NSDateExtentions.swift
//  Conventions
//
//  Created by David Bahat on 2/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

extension Date {
    func format(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = dateFormat;
        dateFormatter.locale = Locale(identifier: "iw-IL")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self);
    }
    
    func addDays(_ days: Int) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: days, to: self, options: [])!;
    }
    
    func addHours(_ hours: Int) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.hour, value: hours, to: self, options: [])!;
    }
    
    func addMinutes(_ minutes: Int) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: minutes, to: self, options: [])!;
    }
    
    func clearMinutesComponent() -> Date {
        let gregorian = Calendar(identifier:Calendar.Identifier.gregorian)
        let components = (gregorian as NSCalendar).components([.year, .month, .day, .hour], from: self)
        (components as NSDateComponents).timeZone = TimeZone.current
        return gregorian.date(from: components) ?? self
    }
    
    func moveToNextRoundHour() -> Date {
        if self.timeIntervalSince(self.clearMinutesComponent()) > 0 {
            return self.clearMinutesComponent().addHours(1)
        }
        return self.clearMinutesComponent()
    }
    
    func clearTimeComponent() -> Date! {
        let gregorian = Calendar(identifier:Calendar.Identifier.gregorian)
        let components = (gregorian as NSCalendar).components([.year, .month, .day], from: self)
        (components as NSDateComponents).timeZone = TimeZone(identifier: "GMT")
        return gregorian.date(from: components)!
    }
    
    static func from(year:Int, month:Int, day:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        (dateComponents as NSDateComponents).timeZone = TimeZone(identifier: "GMT")
        (dateComponents as NSDateComponents).calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        
        let gregorian = Calendar(identifier:Calendar.Identifier.gregorian)
        return gregorian.date(from: dateComponents)!
    }
    
    static func parse(_ date: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.date(from: date)
    }
    
    static func now() -> Date {
        return Date()
            // uncomment for testing date dependent components (e.g. the homeViewController)
            //.from(year: 2017, month: 9, day: 30)
    }
}
