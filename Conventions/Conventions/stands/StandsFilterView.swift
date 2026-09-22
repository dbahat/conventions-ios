//
//  StandsFilterView.swift
//  Conventions
//

import SwiftUI

struct StandsFilterView: View {
    let stands: [Stand]
    @ObservedObject var filterState: StandAreasSearchState

    @State private var isActiveOnlySelected = false
    @State private var isDiscountedOnlySelected = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var categories: [String] {
        var seen = Set<String>()
        return stands
            .map(\.category)
            .filter { !$0.isEmpty }
            .filter { seen.insert($0).inserted }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    private var tags: [String] {
        var seen = Set<String>()
        return stands
            .flatMap { $0.tags }
            .filter { seen.insert($0).inserted }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    private var matchingCount: Int {
        var matching = filterState.selectedCategories.isEmpty
            ? stands
            : stands.filter { filterState.selectedCategories.contains($0.category) }
        if !filterState.selectedTags.isEmpty {
            matching = matching.filter { !filterState.selectedTags.isDisjoint(with: $0.tags) }
        }
        return matching.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 16) {
                Text("נמצאו \(matchingCount) דוכנים")
                    .font(.system(size: 15))
                    .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                    .frame(maxWidth: .infinity, alignment: .trailing)

                HStack {
                    Button("נקה הכל") {
                        filterState.selectedCategories.removeAll()
                        filterState.selectedTags.removeAll()
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(uiColor: Colors.standFilterSelectedColor))

                    Spacer()

                    Text("סינון")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(uiColor: Colors.standsCardTextColor))
                }

                LazyVGrid(columns: columns, spacing: 12) {
                    categoryItem(
                        "דוכנים פעילים",
                        isSelected: isActiveOnlySelected,
                        onToggle: { isActiveOnlySelected.toggle() }
                    )

                    categoryItem(
                        "דוכנים בהנחה",
                        isSelected: isDiscountedOnlySelected,
                        onToggle: { isDiscountedOnlySelected.toggle() }
                    )
                }
                .environment(\.layoutDirection, .rightToLeft)
                
                Text("סוג דוכן")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(uiColor: Colors.standsCardTextColor))

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        categoryItem(
                            category,
                            isSelected: filterState.selectedCategories.contains(category),
                            onToggle: { toggleCategory(category) }
                        )
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)

                if !tags.isEmpty {
                    Text("תגיות")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(uiColor: Colors.standsCardTextColor))

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(tags, id: \.self) { tag in
                            categoryItem(
                                tag,
                                isSelected: filterState.selectedTags.contains(tag),
                                onToggle: { toggleTag(tag) }
                            )
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(uiColor: Colors.standsFilterScreenBackgroundColor).ignoresSafeArea())
    }

    private func categoryItem(_ category: String, isSelected: Bool, onToggle: @escaping () -> Void) -> some View {
        Button(action: onToggle) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? Color(uiColor: Colors.standFilterSelectedColor) : Color(uiColor: Colors.standsCardSubtitleColor))
                
                Text(category)
                    .font(.system(size: 13))
                    .foregroundColor(Color(uiColor: Colors.standsCardTextColor))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }

    private func toggleCategory(_ category: String) {
        if filterState.selectedCategories.contains(category) {
            filterState.selectedCategories.remove(category)
        } else {
            filterState.selectedCategories.insert(category)
        }
    }

    private func toggleTag(_ tag: String) {
        if filterState.selectedTags.contains(tag) {
            filterState.selectedTags.remove(tag)
        } else {
            filterState.selectedTags.insert(tag)
        }
    }
}

#Preview {
    StandsFilterView(
        stands: [
            Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: ["מסע בזמן", "כסף"], tableIds: nil, discountOrga: "TRUE", dates: [], url: "", logo: nil),
            Stand(id: "2", name: "אטלנטיס", category: "דוכן מסחרי", area: StandArea(id: "2", title: "א׳"), description: "", tags: ["עוד כסף"], tableIds: nil, discountOrga: "FALSE", dates: [], url: "", logo: nil),
            Stand(id: "3", name: "אטלנטיס", category: "עוד משהו", area: StandArea(id: "2", title: "א׳"), description: "", tags: ["אומנות", "משחק תפקידים ריצפתי"], tableIds: nil, discountOrga: "FALSE", dates: [], url: "", logo: nil),
        ],
        filterState: StandAreasSearchState()
    )
}
