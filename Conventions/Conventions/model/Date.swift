//
//  Date.swift
//  Conventions
//
//  Created by David Bahat on 2/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Date {
    class func from(year year:Int, month:Int, day:Int) -> NSDate {
        let dateComponents = NSDateComponents();
        dateComponents.year = year;
        dateComponents.month = month;
        dateComponents.day = day;
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian);
        return gregorian!.dateFromComponents(dateComponents)!;
    }
}
