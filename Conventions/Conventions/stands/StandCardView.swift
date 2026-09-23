//
//  StandCardView.swift
//  Conventions
//

import SwiftUI

struct StandCardView: View {
    let stand: Stand
    var showArea: Bool = false
    var showTableIds: Bool = true
    var searchText: String = ""
    var selected: Bool = false
    var onMoreInfoTapped: (() -> Void)? = nil

    private var subtitleText: String {
        if showArea {
            return stand.area?.title ?? ""
        }
        guard showTableIds, let tableIds = stand.tableIds else { return "" }
        return [tableIds.from, tableIds.to].compactMap { $0 }.joined(separator: "-")
    }
    var body: some View {
        HStack(spacing: 8) {
            if let onMoreInfoTapped {
                Button(action: onMoreInfoTapped) {
                    Text("מידע נוסף")
                        .font(.system(size: 16))
                        .foregroundColor(Color(uiColor: Colors.standCardMoreInfoColor))
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .trailing, spacing: 8) {
                Text.highlighted(
                    stand.name,
                    searchText: searchText,
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
                            .cornerRadius(10)
                    }

                    Text.highlighted(
                        subtitleText.isEmpty ? " " : subtitleText,
                        searchText: searchText,
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
                .padding(.all, 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(uiColor: Colors.standsCardBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selected ? Color(uiColor: Colors.standCardSelectedFrame) : .clear, lineWidth: 1)
        )
        .shadow(color: selected ? .black.opacity(0.30) : .clear, radius: 4, x: 0, y: 0)
    }
}

#Preview {
    VStack(spacing: 12) {
        StandCardView(stand: Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: "12", to: "15", count: 4, list: ["12", "13", "14", "15"], raw: "12-15"), discountOrga: "TRUE", dates: ["2026-09-29T00:00:00+03:00", "2026-09-30T12:00:00+03:00"], url: "", logo: nil), onMoreInfoTapped: {})
        StandCardView(stand: Stand(id: "2", name: "אטלנטיס", category: "דוכן מסחרי", area: StandArea(id: "2", title: "א׳"), description: "", tags: [], tableIds: StandTableIds(from: "3", to: "3", count: 1, list: ["3"], raw: "3"), discountOrga: "FALSE", dates: [], url: "", logo: nil), showArea: true, searchText: "אטל")
        StandCardView(stand: Stand(id: "3", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: "12", to: "15", count: 4, list: ["12", "13", "14", "15"], raw: "12-15"), discountOrga: "TRUE", dates: ["2026-09-29T00:00:00+03:00", "2026-09-30T12:00:00+03:00"], url: "", logo: nil), selected: true)
    }
    .padding(16)
}
