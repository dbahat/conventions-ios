//
//  SearchCategory.swift
//  Conventions
//
//  Created by David Bahat on 9/26/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

enum AggregatedSearchCategory {
    case lectures
    case games
    case workshops
    case shows
    case others
    
    var categories: Array<String> {
        switch self {
        case .lectures:
            return ["הרצאה" ,"פאנל"]
        case .games:
            return ["משחק שולחני" ,"משחק תפקידים חי" ,"משחק תפקידים לילדים", "מיוחד" ,"טורניר"]
        case .shows:
            return ["הקרנה" ,"מופע", "מופע מוזיקלי", "הקרנה מונחית"]
        case .workshops:
            return ["סדנה"]
        case .others:
            return []
        }
    }
    
    func containsCategory(_ eventCategory: String) -> Bool {
        if self == .others {
            return !AggregatedSearchCategory.lectures.containsCategory(eventCategory)
                && !AggregatedSearchCategory.shows.containsCategory(eventCategory)
                && !AggregatedSearchCategory.workshops.containsCategory(eventCategory)
        }
        
        return categories.contains(eventCategory)
    }
}
