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
}

struct StandTableIds: Codable {
    let from: Int?
    let to: Int?
    let count: Int?
    let list: [Int]?
    let raw: String
}

struct Stand: Codable {
    let id: String
    let name: String
    let category: String
    let area: StandArea?
    let description: String
    let tags: [String]
    let tableIds: StandTableIds?
    let discountOrga: String
    let dates: [String]
    let url: String
    let logo: String?

    var isDiscountOrga: Bool { discountOrga.uppercased() == "TRUE" }
}
