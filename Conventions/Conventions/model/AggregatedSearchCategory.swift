//
//  SearchCategory.swift
//  Conventions
//
//  Created by David Bahat on 9/26/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

enum AggregatedSearchCategory {
    case Lectures
    case Games
    case Shows
    case Others
    
    var categories: Array<String> {
        switch self {
        case Lectures:
            return ["הרצאה" ,"פאנל"]
        case Games:
            return ["משחק שולחני" ,"משחק תפקידים חי" ,"מיוחד" ,"טורניר"]
        case Shows:
            return ["הקרנה" ,"מופע"]
        case Others:
            return []
        }
    }
    
    func containsCategory(eventCategory: String) -> Bool {
        if self == .Others {
            return !AggregatedSearchCategory.Lectures.containsCategory(eventCategory)
                && !AggregatedSearchCategory.Games.containsCategory(eventCategory)
                && !AggregatedSearchCategory.Shows.containsCategory(eventCategory)
        }
        
        return categories.contains(eventCategory)
    }
}
