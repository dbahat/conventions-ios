//
//  TextExtentions.swift
//  Conventions
//

import SwiftUI

extension Text {
    // Font/color must be applied per-segment rather than chained onto the returned
    // compound Text, since a modifier chained onto a concatenated Text overrides the
    // per-segment styling of every run, erasing the highlight.
    static func highlighted(_ text: String, searchText: String, font: Font, color: Color) -> Text {
        guard !searchText.isEmpty else { return Text(text).font(font).foregroundColor(color) }

        var result = Text("")
        var remaining = Substring(text)
        while let range = remaining.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) {
            let before = remaining[remaining.startIndex..<range.lowerBound]
            if !before.isEmpty {
                result = result + Text(before).font(font).foregroundColor(color)
            }
            result = result + Text(remaining[range])
                .font(font.bold())
                .foregroundColor(Color(uiColor: Colors.standHighlightedTextColor))
            remaining = remaining[range.upperBound...]
        }
        return result + Text(remaining).font(font).foregroundColor(color)
    }
}
