//
//  DateFilterControl.swift
//  Conventions
//
//  Created by David Bahat on 9/27/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class DateFilterControl : UISegmentedControl {
    
    private var toDate = NSDate()
    private let SecondsInDay : Double = 60 * 60 * 24
    
    var selectedDate: NSDate {
        get {
            return toDate.addDays(-selectedSegmentIndex)
        }
    }
    
    func setDates(fromDate fromDate: NSDate, toDate: NSDate) {
        self.toDate = toDate.clearTimeComponent()
        
        removeAllSegments()
        for i in 0...getNumberOfDays(fromDate: fromDate.clearTimeComponent(), toDate: self.toDate) {
            insertSegmentWithTitle(toDate.addDays(-i).format("EEE (dd.MM)"), atIndex: i, animated: false)
        }
        
        // By default select the last segment to support RTL
        selectedSegmentIndex = numberOfSegments - 1
        
        tintColor = Colors.colorAccent
    }
    
    func selectDate(date: NSDate) {
        let dayDiff = getNumberOfDays(fromDate: date, toDate: toDate)
        let segmentToSelect = dayDiff
        
        if segmentToSelect < 0 || segmentToSelect >= numberOfSegments {
            // when the requested date is before or past the convention date, don't select anything
            return
        }
        
        selectedSegmentIndex = segmentToSelect
    }
    
    // returns the number of days between 2 NSDates, rounded up
    private func getNumberOfDays(fromDate fromDate: NSDate, toDate: NSDate) -> Int {
        return Int(ceil((toDate.timeIntervalSince1970 - fromDate.timeIntervalSince1970) / SecondsInDay))
    }
}
