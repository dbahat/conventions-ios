//
//  DateFilterControl.swift
//  Conventions
//
//  Created by David Bahat on 9/27/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class DateFilterControl : UISegmentedControl {
    
    var toDate = NSDate()
    
    var selectedDate: NSDate {
        get {
            return toDate.addDays(-selectedSegmentIndex)
        }
    }
    
    func setDates(fromDate fromDate: NSDate, toDate: NSDate) {
        self.toDate = toDate
        
        removeAllSegments()
        for i in 0...getNumberOfDays(fromDate: fromDate, toDate: toDate) {
            insertSegmentWithTitle(toDate.addDays(-i).format("EEE (dd.MM)"), atIndex: i, animated: false)
        }
        
        // By default select the last segment to support RTL
        selectedSegmentIndex = numberOfSegments - 1
        
        tintColor = Colors.colorAccent
    }
    
    func getNumberOfDays(fromDate fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        return calendar.components([.Day], fromDate: fromDate, toDate: toDate, options: []).day
    }
}
