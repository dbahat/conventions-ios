//
//  Stand.swift
//  Conventions
//
//  Created by David Bahat on 9/5/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import Foundation

struct StandArea: Codable {
    let id: String
    let title: String

    var mapImageName: String? {
        switch title {
        case "מגרש": return "Court"
        case "דה וינצ'י": return "DaVinci"
        case "סינמטק": return "Cinematheque"
        case "פופ-אפ": return "PopUp"
        case "אשכול": return "Pais"
        default: return nil
        }
    }
}

struct StandTableIds: Codable {
    let from: String?
    let to: String?
    let count: Int?
    let list: [String]?
    let raw: String
}

struct Stand: Codable {
    let id: String
    let name: String
    var category: String
    let area: StandArea?
    let description: String
    let tags: [String]
    let tableIds: StandTableIds?
    let discountOrga: String
    let dates: [String]
    let url: String
    let logo: String?

    var isDiscountOrga: Bool { discountOrga.uppercased() == "TRUE" }

    var isActive: Bool {
        let today = Date.now().clearTimeComponent()
        if today < Convention.date || today > Convention.endDate { return true }
        return dates.contains { dateString in
            guard let date = Date.parse(dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") else { return false }
            return date.clearTimeComponent() == today
        }
    }

    var categoryIconName: String {
        switch category {
        case "איור": return "StandMenuDrawing"
        case "מלאכת יד": return "StandMenuHandicraft"
        case "משחקי קופסה": return "StandMenuBoardGames"
        case "ספרים", "קומיקס": return "StandMenuBooks"
        default: return "StandIcon"
        }
    }
}
