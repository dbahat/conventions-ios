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
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            ScrollView {
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
                        .foregroundColor(Color(uiColor: Colors.colorAccent))

                        Spacer()

                        Text("סוג דוכן")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(uiColor: Colors.standsCardTitleColor))
                    }

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            categoryItem(category)
                        }
                    }
                }
                .padding(16)
            }
        }
    }

    private func categoryItem(_ category: String) -> some View {
        let isSelected = filterState.selectedCategories.contains(category)

        return Button(action: { toggle(category) }) {
            HStack(spacing: 8) {
                // ZStack (not .background/.overlay, which size to whichever view they're attached to)
                // takes the max width and max height of both children independently: the real text
                // drives the width (so it still wraps normally), while the 2-line ghost text drives
                // the height whenever the category name only needs 1 line, keeping every grid item
                // the same height regardless of name length.
                ZStack(alignment: .topTrailing) {
                    Text("A\nA")
                        .font(.system(size: 15))
                        .opacity(0)

                    Text(category)
                        .font(.system(size: 15))
                        .foregroundColor(Color(uiColor: Colors.standsCardTitleColor))
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                }

                Spacer(minLength: 4)

                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? Color(uiColor: Colors.colorAccent) : Color(uiColor: Colors.standsChevronColor))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color(uiColor: Colors.standsCardBackgroundColor))
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
            Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: "אולם 1", tableIds: nil, discountOrga: "TRUE", url: "", logo: nil),
            Stand(id: "2", name: "אטלנטיס", category: "דוכן מסחרי", area: "א׳", tableIds: nil, discountOrga: "FALSE", url: "", logo: nil),
        ],
        filterState: StandAreasSearchState()
    )
}
