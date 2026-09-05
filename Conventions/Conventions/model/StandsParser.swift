//
//  StandsParser.swift
//  Conventions
//
//  Created by David Bahat on 9/5/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import Foundation

class StandsParser {
    private struct ApiResponse: Decodable {
        let booths: [Stand]
    }

    func parse(data: Data) -> Array<Stand>? {
        guard let response = try? JSONDecoder().decode(ApiResponse.self, from: data) else {
            print("Failed to deserialize stands")
            return nil
        }

        return response.booths
    }

    func parseCached(data: Data) -> Array<Stand>? {
        guard let stands = try? JSONDecoder().decode([Stand].self, from: data) else {
            print("Failed to deserialize cached stands")
            return nil
        }

        return stands
    }
}
