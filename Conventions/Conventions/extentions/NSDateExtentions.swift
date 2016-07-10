//
//  NSDateExtentions.swift
//  Conventions
//
//  Created by David Bahat on 2/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

extension NSDate {
    func format(dateFormat: String!) -> String! {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = dateFormat;
        dateFormatter.locale = NSLocale.systemLocale();
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
    
    func clearMinutesComponent() -> NSDate! {
        return NSDate.parse(self.format("yyyy-MM-dd HH"), dateFormat: "yyyy-MM-dd HH");
    }
    
    func moveToNextRoundHour() -> NSDate! {
        if self.timeIntervalSinceDate(self.clearMinutesComponent()) > 0 {
            return self.clearMinutesComponent().addHours(1);
        }
        return self.clearMinutesComponent();
    }
    
    static func from(year year:Int, month:Int, day:Int) -> NSDate {
        let dateComponents = NSDateComponents();
        dateComponents.year = year;
        dateComponents.month = month;
        dateComponents.day = day;
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian);
        return gregorian!.dateFromComponents(dateComponents)!;
    }
    
    static func parse(date: String, dateFormat: String) -> NSDate? {
        let dateFormatter = NSDateFormatter();
        dateFormatter.locale = NSLocale.systemLocale();
        dateFormatter.dateFormat = dateFormat;
        return dateFormatter.dateFromString(date);
    }
}