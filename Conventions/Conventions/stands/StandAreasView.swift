//
//  StandAreasView.swift
//  Conventions
//

import SwiftUI

final class StandAreasSearchState: ObservableObject {
    @Published var searchText: String = ""
    @Published var isActive: Bool = false
}

struct StandAreasView: View {
    let refresher: StandsRefresher
    @ObservedObject var searchState: StandAreasSearchState
    let onSelectArea: (String) -> Void

    @State private var stands: [Stand] = []

    private var areas: [String] {
        var seen = Set<String>()
        return stands
            .map(\.area)
            .filter { !$0.isEmpty }
            .filter { seen.insert($0).inserted }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    private var filteredStands: [Stand] {
        let searchText = searchState.searchText
        let matching = searchText.isEmpty ? stands : stands.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
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
            ForEach(areas, id: \.self) { area in
                Button(action: { onSelectArea(area) }) {
                    HStack(spacing: 10) {
                        Spacer(minLength: 0)
                        Text(area)
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
        if filteredStands.isEmpty {
            Text("לא נמצאו דוכנים")
                .font(.system(size: 15))
                .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                .padding(.top, 40)
        } else {
            ForEach(filteredStands, id: \.id) { stand in
                StandCardView(stand: stand, showArea: true)
            }
        }
    }

    private func updateStands() {
        stands = refresher.getAll()
    }
}

#Preview {
    StandAreasView(refresher: StandsRefresher(), searchState: StandAreasSearchState()) { area in
        print("Selected area: \(area)")
    }
}
