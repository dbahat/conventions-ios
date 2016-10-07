//
//  NSDateExtentions.swift
//  Conventions
//
//  Created by David Bahat on 2/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

extension NSDate {
    func format(dateFormat: String) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = dateFormat;
        dateFormatter.locale = NSLocale(localeIdentifier: "iw-IL")
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        return dateFormatter.stringFromDate(self);
    }
    
    func addDays(days: Int) -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: days, toDate: self, options: [])!;
    }
    
    func addHours(hours: Int) -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        return calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: hours, toDate: self, options: [])!;
    }
    
    func addMinutes(minutes: Int) -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        return calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: minutes, toDate: self, options: [])!;
    }
    
    func clearMinutesComponent() -> NSDate {
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let components = gregorian!.components([.Year, .Month, .Day, .Hour], fromDate: self)
        components.timeZone = NSTimeZone.systemTimeZone()
        return gregorian?.dateFromComponents(components) ?? self
    }
    
    func moveToNextRoundHour() -> NSDate {
        if self.timeIntervalSinceDate(self.clearMinutesComponent()) > 0 {
            return self.clearMinutesComponent().addHours(1)
        }
        return self.clearMinutesComponent()
    }
    
    func clearTimeComponent() -> NSDate! {
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let components = gregorian!.components([.Year, .Month, .Day], fromDate: self)
        components.timeZone = NSTimeZone(name: "GMT")
        return gregorian?.dateFromComponents(components)!
    }
    
    static func from(year year:Int, month:Int, day:Int) -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = NSTimeZone(name: "GMT")
        dateComponents.calendar = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        return gregorian!.dateFromComponents(dateComponents)!
    }
    
    static func parse(date: String, dateFormat: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        return dateFormatter.dateFromString(date)
    }
}
