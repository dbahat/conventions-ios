//
//  NSDateExtentions.swift
//  Conventions
//
//  Created by David Bahat on 2/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

extension Date {
    public static let timeZone = TimeZone(identifier: "Asia/Jerusalem")!
    private static var gregorianCalendar = Calendar(identifier:Calendar.Identifier.gregorian) {
        didSet {
            Date.gregorianCalendar.timeZone = Date.timeZone
        }
    }
    
    func format(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "he-il")
        dateFormatter.timeZone = Date.timeZone
        return dateFormatter.string(from: self);
    }
    
    func addDays(_ days: Int) -> Date {
        return Date.gregorianCalendar.date(byAdding: .day, value: days, to: self, wrappingComponents: false)!
    }
    
    func addHours(_ hours: Int) -> Date {
        return Date.gregorianCalendar.date(byAdding: .hour, value: hours, to: self, wrappingComponents: false)!
    }
    
    func addMinutes(_ minutes: Int) -> Date {
        return Date.gregorianCalendar.date(byAdding: .minute, value: minutes, to: self, wrappingComponents: false)!
    }
    
    func clearMinutesComponent() -> Date {
        let components = Date.gregorianCalendar.dateComponents(in: Date.timeZone, from: self)
        return Date.from(year: components.year!, month: components.month!, day: components.day!, hour: components.hour!, minute: 0)
    }
    
    func moveToNextRoundHour() -> Date {
        if self.timeIntervalSince(self.clearMinutesComponent()) > 0 {
            return self.clearMinutesComponent().addHours(1)
        }
        return self.clearMinutesComponent()
    }
    
    func clearTimeComponent() -> Date! {
        let components = Date.gregorianCalendar.dateComponents(in: Date.timeZone, from: self)
        return Date.from(year: components.year!, month: components.month!, day: components.day!)
    }
    
    static func from(year:Int, month:Int, day:Int) -> Date {
        return from(year: year, month: month, day: day, hour: 0, minute: 0)
    }
    
    static func from(year:Int, month:Int, day:Int, hour: Int, minute: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.timeZone = Date.timeZone

        return Date.gregorianCalendar.date(from: dateComponents)!
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
            //.from(year: 2021, month: 9, day:22, hour: 13, minute: 0)
    }
}
