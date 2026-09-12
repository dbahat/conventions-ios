//
//  StandsFilterView.swift
//  Conventions
//

import SwiftUI

struct StandsFilterView: View {
    let stands: [Stand]
    @ObservedObject var filterState: StandAreasSearchState

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var categories: [String] {
        var seen = Set<String>()
        return stands
            .map(\.category)
            .filter { !$0.isEmpty }
            .filter { seen.insert($0).inserted }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    private var matchingCount: Int {
        filterState.selectedCategories.isEmpty
            ? stands.count
            : stands.filter { filterState.selectedCategories.contains($0.category) }.count
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Text("נמצאו \(matchingCount) דוכנים")
                .font(.system(size: 15))
                .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                .frame(maxWidth: .infinity, alignment: .trailing)

            HStack {
                Button("נקה הכל") {
                    filterState.selectedCategories.removeAll()
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(uiColor: Colors.standFilterSelectedColor))

                Spacer()

                Text("סוג דוכן")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(uiColor: Colors.standsCardTextColor))
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    categoryItem(category)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(uiColor: Colors.standsFilterScreenBackgroundColor).ignoresSafeArea())
    }

    private func categoryItem(_ category: String) -> some View {
        let isSelected = filterState.selectedCategories.contains(category)

        return Button(action: { toggle(category) }) {
            HStack(spacing: 8) {
                Text(category)
                    .font(.system(size: 13))
                    .foregroundColor(Color(uiColor: Colors.standsCardTextColor))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? Color(uiColor: Colors.standFilterSelectedColor) : Color(uiColor: Colors.standsCardSubtitleColor))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }

    private func toggle(_ category: String) {
        if filterState.selectedCategories.contains(category) {
            filterState.selectedCategories.remove(category)
        } else {
            filterState.selectedCategories.insert(category)
        }
    }
}

#Preview {
    StandsFilterView(
        stands: [
            Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: nil, discountOrga: "TRUE", dates: [], url: "", logo: nil),
            Stand(id: "2", name: "אטלנטיס", category: "דוכן מסחרי", area: StandArea(id: "2", title: "א׳"), description: "", tags: [], tableIds: nil, discountOrga: "FALSE", dates: [], url: "", logo: nil),
        ],
        filterState: StandAreasSearchState()
    )
}
