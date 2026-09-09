//
//  Stand.swift
//  Conventions
//
//  Created by David Bahat on 9/5/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import Foundation

struct StandTableIds: Codable {
    let from: Int?
    let to: Int?
    let count: Int?
    let raw: String
}

struct Stand: Codable {
    let id: String
    let name: String
    let category: String
    let area: String
    let tableIds: StandTableIds?
    let discountOrga: String
    let url: String
    let logo: String?

    var isDiscountOrga: Bool { discountOrga.uppercased() == "TRUE" }
}
