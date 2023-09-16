//
//  DateFilterControl.swift
//  Conventions
//
//  Created by David Bahat on 9/27/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class DateFilterControl : UISegmentedControl {
    
    private var toDate = Date.now()
    private let SecondsInDay : Double = 60 * 60 * 24
    private var segmentTitles : Array<String>?
    private var segmentDates : Array<Date> = []
    
    var selectedDate: Date {
        get {
            return segmentDates[selectedSegmentIndex]
        }
    }
    
    func setDates(fromDate: Date, toDate: Date) {
        self.toDate = toDate.clearTimeComponent()
        
        removeAllSegments()
        segmentTitles = []
        segmentDates = []
        for i in 0...getNumberOfDays(fromDate: fromDate.clearTimeComponent(), toDate: self.toDate) {
            let date = toDate.addDays(-i)
            if isWeekend(date) {
                continue
            }
            let segmentTitle = date.format("EEE (dd.MM)")
            insertSegment(withTitle: segmentTitle , at: i, animated: false)
            segmentTitles?.append(segmentTitle)
            segmentDates.append(date)
        }
        
        // By default select the last segment to support RTL
        selectedSegmentIndex = numberOfSegments - 1
        
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = Colors.datePickerColor
        } else {
            tintColor = Colors.datePickerColor
        }
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.datePickerTextColor]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        backgroundColor = Colors.datePickerBackgroundColor
    }
    
    func updateNumberOfResultsPerSegment(_ resultsPerSegment: Array<Int>) {
        for i in 0...numberOfSegments-1 {
            let currentTitle = segmentTitles?[i] ?? ""
            let newTitle = String(format: "%@ (%d אירועים)", currentTitle, resultsPerSegment[i])
            setTitle(newTitle, forSegmentAt: i)
        }
    }
    
    func resetNumberOfResults() {
        for i in 0...numberOfSegments-1 {
            let currentTitle = segmentTitles?[i] ?? ""
            setTitle(currentTitle, forSegmentAt: i)
        }
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
    private func getNumberOfDays(fromDate: Date, toDate: Date) -> Int {
        return Int(ceil((toDate.timeIntervalSince1970 - fromDate.timeIntervalSince1970) / SecondsInDay))
    }
    
    private func isWeekend(_ date: Date) -> Bool {
        return Calendar.current.component(.weekday, from: date) == 6 || Calendar.current.component(.weekday, from: date) == 7
    }
}
