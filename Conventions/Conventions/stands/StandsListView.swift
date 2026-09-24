//
//  StandsListView.swift
//  Conventions
//

import SwiftUI
import UIKit

struct StandsListView: View {
    let stands: [Stand]
    var scrollToStandId: String? = nil
    let mapImageName: String?
    // Per-area cap, see StandArea.maximumZoomScale.
    var maximumZoomScale: CGFloat = 3
    // Resolves a stand's table rects (in the map image's own point coordinates) so its
    // tables can be highlighted and zoomed to on the inline map when its card is selected.
    var tableRects: (Stand) -> [CGRect] = { _ in [] }
    let onExpandMapTapped: (Stand?) -> Void
    let onStandTapped: (Stand) -> Void

    @State private var selectedStandId: String?

    private var selectedStand: Stand? {
        stands.first { $0.id == selectedStandId }
    }

    private var highlightedRects: [CGRect] {
        selectedStand.map(tableRects) ?? []
    }

    private var sortedStands: [Stand] {
        stands.sorted(by: Self.isOrderedBefore)
    }

    private static func isOrderedBefore(_ lhs: Stand, _ rhs: Stand) -> Bool {
        if lhs.isActive != rhs.isActive {
            return lhs.isActive
        }

        let lhsTable = tableSortKey(lhs.tableIds?.from)
        let rhsTable = tableSortKey(rhs.tableIds?.from)

        if lhsTable.hasFrom != rhsTable.hasFrom {
            return lhsTable.hasFrom
        }
        if lhsTable.letters != rhsTable.letters {
            return lhsTable.letters.localizedStandardCompare(rhsTable.letters) == .orderedAscending
        }
        if lhsTable.number != rhsTable.number {
            return lhsTable.number < rhsTable.number
        }

        return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }

    private static func tableSortKey(_ from: String?) -> (hasFrom: Bool, letters: String, number: Int) {
        guard let from, !from.isEmpty else { return (false, "", 0) }
        let letters = from.prefix { $0.isLetter }
        let number = Int(from.dropFirst(letters.count)) ?? 0
        return (true, String(letters), number)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("AppBackground")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    if let mapImageName {
                        ZoomableImageView(image: UIImage(named: mapImageName), highlightedRects: highlightedRects, maximumZoomScale: maximumZoomScale)
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3)
                            .overlay(alignment: .bottomLeading) {
                                Button(action: { onExpandMapTapped(selectedStand) }) {
                                    Image("ZoomOut")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color(uiColor: Colors.standZoomOutIconColor))
                                        .padding(10)
                                        .background(Circle().fill(Color(uiColor: Colors.standZoomOutContainerColor)))
                                        .shadow(radius: 3)
                                }
                                .padding(12)
                            }
                    }

                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                if stands.isEmpty {
                                    Text("לא נמצאו דוכנים באזור זה")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                                        .padding(.top, 40)
                                } else {
                                    ForEach(sortedStands, id: \.id) { stand in
                                        Button(action: { selectedStandId = stand.id }) {
                                            StandCardView(
                                                stand: stand,
                                                showTableIds: mapImageName != nil,
                                                selected: selectedStandId == stand.id,
                                                onMoreInfoTapped: { onStandTapped(stand) }
                                            )
                                        }
                                        .buttonStyle(.plain)
                                        .id(stand.id)
                                    }
                                }
                            }
                            .padding(16)
                        }
                        .onAppear {
                            guard let scrollToStandId else { return }
                            selectedStandId = scrollToStandId
                            DispatchQueue.main.async {
                                withAnimation {
                                    proxy.scrollTo(scrollToStandId, anchor: .top)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StandsListView(stands: [
        Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: "1", to: "2", count: 2, list: ["1", "2"], raw: "1-2"), discountOrga: "TRUE", dates: [], url: "", logo: nil),
        Stand(id: "2", name: "הוצאת ספרים כלשהי", category: "מוציאים לאור", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: "5", to: "5", count: 1, list: ["5"], raw: "5"), discountOrga: "FALSE", dates: [], url: "", logo: nil),
        Stand(id: "3", name: "דוכן משחקי תפקידים", category: "משחקים", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: nil, discountOrga: "FALSE", dates: [], url: "", logo: nil),
    ], mapImageName: "Court", onExpandMapTapped: { _ in }, onStandTapped: { _ in })
}

#Preview("Empty") {
    StandsListView(stands: [], mapImageName: "Court", onExpandMapTapped: { _ in }, onStandTapped: { _ in })
}

#Preview("No map") {
    StandsListView(stands: [], mapImageName: nil, onExpandMapTapped: { _ in }, onStandTapped: { _ in })
}
