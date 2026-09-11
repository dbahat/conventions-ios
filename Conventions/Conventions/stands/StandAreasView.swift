//
//  StandAreasView.swift
//  Conventions
//

import SwiftUI

final class StandAreasSearchState: ObservableObject {
    @Published var searchText: String = ""
    @Published var isActive: Bool = false
    @Published var selectedCategories: Set<String> = []
}

struct StandAreasView: View {
    let refresher: StandsRefresher
    @ObservedObject var searchState: StandAreasSearchState
    let onSelectArea: (StandArea) -> Void
    let onOpenFilter: () -> Void

    @State private var stands: [Stand] = []

    private var areas: [StandArea] {
        var seen = Set<String>()
        return stands
            .compactMap(\.area)
            .filter { seen.insert($0.id).inserted }
            .sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
    }

    private var filteredStands: [Stand] {
        let searchText = searchState.searchText
        let categories = searchState.selectedCategories
        var matching = categories.isEmpty ? stands : stands.filter { categories.contains($0.category) }
        if !searchText.isEmpty {
            matching = matching.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return matching.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 12) {
                    if !searchState.isActive {
                        areasContent
                            .transition(.opacity)
                    } else {
                        standsContent
                            .transition(.opacity)
                    }
                }
                .padding(16)
                .animation(.easeInOut(duration: 0.25), value: searchState.isActive)
            }
        }
        .onAppear {
            updateStands()
            refresher.refresh { _ in updateStands() }
        }
    }

    @ViewBuilder
    private var areasContent: some View {
        if areas.isEmpty {
            Text("לא נמצאו דוכנים")
                .font(.system(size: 15))
                .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                .padding(.top, 40)
        } else {
            ForEach(areas, id: \.id) { area in
                Button(action: { onSelectArea(area) }) {
                    HStack(spacing: 10) {
                        Spacer(minLength: 0)
                        Text(area.title)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color(uiColor: Colors.standsCardTitleColor))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(uiColor: Colors.standsChevronColor))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color(uiColor: Colors.standsCardBackgroundColor))
                    .cornerRadius(4)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var standsContent: some View {
        filterHeader

        if filteredStands.isEmpty {
            Text("לא נמצאו דוכנים")
                .font(.system(size: 15))
                .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                .padding(.top, 40)
        } else {
            ForEach(filteredStands, id: \.id) { stand in
                StandCardView(stand: stand, showArea: true, searchText: searchState.searchText)
            }
        }
    }

    private var filterHeader: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Button(action: onOpenFilter) {
                HStack(spacing: 6) {
                    Text("סינון")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(uiColor: Colors.standsCardTitleColor))
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(uiColor: Colors.standsChevronColor))
                }
            }
            .buttonStyle(.plain)

            Text("נמצאו \(filteredStands.count) דוכנים")
                .font(.system(size: 13))
                .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func updateStands() {
        stands = refresher.getAll()
    }
}

#Preview {
    StandAreasView(refresher: StandsRefresher(), searchState: StandAreasSearchState(), onSelectArea: { area in
        print("Selected area: \(area)")
    }, onOpenFilter: {
        print("Open filter")
    })
}
