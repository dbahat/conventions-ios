//
//  Stand.swift
//  Conventions
//
//  Created by David Bahat on 9/5/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import UIKit

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

    /// How far a stands map can be pinch/double-tap zoomed in, tuned per area to how
    /// detailed/tightly packed each map's tables are
    var maximumZoomScale: CGFloat {
        switch title {
        case "מגרש": return 4
        case "פופ-אפ", "דה וינצ'י", "אשכול": return 2
        default: return 3
        }
    }

    // Table position sidecars (e.g. "PaisTables") are generated offline by
    // scripts/generate_stand_tables.py from each map's SVG -- tables aren't
    // <text>/have no id in the SVGs, just an outlined glyph shape -- and
    // shipped as Data Sets in the asset catalog: {"<tableId>": [x, y, width,
    // height]}, in the same point coordinates as the map's UIImage.
    private static var tablePositionsCache: [String: [String: CGRect]] = [:]

    /// The map-image-space rects for the given table IDs, silently skipping
    /// any table id that isn't in this area's sidecar (or if there is none).
    func tableRects(for tableIds: [String]) -> [CGRect] {
        guard let mapImageName else { return [] }
        let positions = Self.tablePositions(forMap: mapImageName)
        return tableIds.compactMap { positions[$0] }
    }

    private static func tablePositions(forMap mapImageName: String) -> [String: CGRect] {
        if let cached = tablePositionsCache[mapImageName] {
            return cached
        }
        var result: [String: CGRect] = [:]
        if let asset = NSDataAsset(name: "\(mapImageName)Tables"),
           let raw = try? JSONDecoder().decode([String: [CGFloat]].self, from: asset.data) {
            for (id, values) in raw where values.count == 4 {
                result[id] = CGRect(x: values[0], y: values[1], width: values[2], height: values[3])
            }
        }
        tablePositionsCache[mapImageName] = result
        return result
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
