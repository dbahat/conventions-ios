//
//  DateFilterControl.swift
//  Conventions
//
//  Created by David Bahat on 9/27/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class DateFilterControl : UISegmentedControl {
    
    fileprivate var toDate = Date()
    fileprivate let SecondsInDay : Double = 60 * 60 * 24
    
    var selectedDate: Date {
        get {
            return toDate.addDays(-selectedSegmentIndex)
        }
    }
    
    func setDates(fromDate: Date, toDate: Date) {
        self.toDate = toDate.clearTimeComponent()
        
        removeAllSegments()
        for i in 0...getNumberOfDays(fromDate: fromDate.clearTimeComponent(), toDate: self.toDate) {
            insertSegment(withTitle: toDate.addDays(-i).format("EEE (dd.MM)"), at: i, animated: false)
        }
        
        // By default select the last segment to support RTL
        selectedSegmentIndex = numberOfSegments - 1
        
        tintColor = Colors.colorAccent
    }
    
    func selectDate(_ date: Date) {
        let dayDiff = getNumberOfDays(fromDate: date, toDate: toDate)
        let segmentToSelect = dayDiff
        
        if segmentToSelect < 0 || segmentToSelect >= numberOfSegments {
            // when the requested date is before or past the convention date, don't select anything
            return
        }
        
        selectedSegmentIndex = segmentToSelect
    }
    
    // returns the number of days between 2 NSDates, rounded up
    fileprivate func getNumberOfDays(fromDate: Date, toDate: Date) -> Int {
        return Int(ceil((toDate.timeIntervalSince1970 - fromDate.timeIntervalSince1970) / SecondsInDay))
    }
}
