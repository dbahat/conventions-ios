//
//  StandCardView.swift
//  Conventions
//

import SwiftUI

struct StandCardView: View {
    let stand: Stand
    var showArea: Bool = false
    var searchText: String = ""
    var onMoreInfoTapped: (() -> Void)? = nil

    private var subtitleText: String {
        showArea ? (stand.area?.title ?? "") : (stand.tableIds?.raw ?? "")
    }

    var body: some View {
        HStack(spacing: 12) {
            if let onMoreInfoTapped {
                Button(action: onMoreInfoTapped) {
                    Text("מידע נוסף")
                        .font(.system(size: 16))
                        .foregroundColor(Color(uiColor: Colors.standCardMoreInfoColor))
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .trailing, spacing: 8) {
                highlightedText(
                    stand.name,
                    font: .system(size: 17, weight: .medium),
                    color: Color(uiColor: Colors.standsCardTextColor)
                )
                .lineLimit(1)

                HStack(spacing: 6) {
                    if !stand.isActive {
                        Text("לא פעיל")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(uiColor: Colors.standsCategoryBadgeTextColor))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(uiColor: Colors.standsCategoryBadgeBackgroundColor))
                            .cornerRadius(4)
                    }

                    highlightedText(
                        subtitleText.isEmpty ? " " : subtitleText,
                        font: .system(size: 12, weight: .semibold),
                        color: Color(uiColor: Colors.standCardSubtitleColor)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Image("StandIcon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(Color(uiColor: Colors.standCardIconColor))
        }
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
                .foregroundColor(Color(uiColor: Colors.standHighlightedTextColor))
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
