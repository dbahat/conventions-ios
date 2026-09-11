//
//  StandCardView.swift
//  Conventions
//

import SwiftUI

struct StandCardView: View {
    let stand: Stand
    var showArea: Bool = false
    var searchText: String = ""

    private var badgeText: String {
        let raw = stand.tableIds?.raw ?? ""
        guard showArea else { return raw }
        let areaTitle = stand.area?.title ?? ""
        guard !areaTitle.isEmpty else { return raw }
        guard !raw.isEmpty else { return areaTitle }
        return "\(areaTitle), \(raw)"
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // ZStack (not .background/.overlay, which size to whichever view they're attached to)
            // takes the max width and max height of both children independently: the real text
            // drives the width (so it still wraps normally), while the 2-line ghost text drives
            // the height whenever the real name only needs 1 line, keeping every card's title the
            // same height regardless of name length.
            ZStack(alignment: .topTrailing) {
                Text("A\nA")
                    .font(.system(size: 17, weight: .medium))
                    .opacity(0)

                highlightedText(
                    stand.name,
                    font: .system(size: 17, weight: .medium),
                    color: Color(uiColor: Colors.standsCardTitleColor)
                )
                .lineLimit(2)
            }

            // Badge slot always renders (even with no content) so its height/padding is
            // reserved on every card; it's just made invisible when there's nothing to show.
            highlightedText(
                badgeText.isEmpty ? " " : badgeText,
                font: .system(size: 12, weight: .semibold),
                color: Color(uiColor: Colors.standsCategoryBadgeTextColor)
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color(uiColor: Colors.standsCategoryBadgeBackgroundColor))
            .cornerRadius(4)
            .opacity(badgeText.isEmpty ? 0 : 1)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(uiColor: Colors.standsCardBackgroundColor))
        .cornerRadius(4)
    }

    // Font/color must be applied per-segment rather than chained onto the returned
    // compound Text, since a modifier chained onto a concatenated Text overrides the
    // per-segment styling of every run, erasing the highlight.
    private func highlightedText(_ text: String, font: Font, color: Color) -> Text {
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
                .foregroundColor(Color(uiColor: Colors.colorAccent))
            remaining = remaining[range.upperBound...]
        }
        return result + Text(remaining).font(font).foregroundColor(color)
    }
}

#Preview {
    VStack(spacing: 12) {
        StandCardView(stand: Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: 12, to: 15, count: 4, list: [12, 13, 14, 15], raw: "12-15"), discountOrga: "TRUE", dates: [], url: "", logo: nil))
        StandCardView(stand: Stand(id: "2", name: "אטלנטיס", category: "דוכן מסחרי", area: StandArea(id: "2", title: "א׳"), description: "", tags: [], tableIds: StandTableIds(from: 3, to: 3, count: 1, list: [3], raw: "3"), discountOrga: "FALSE", dates: [], url: "", logo: nil), showArea: true, searchText: "אטל")
    }
    .padding(16)
}
