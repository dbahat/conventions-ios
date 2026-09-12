//
//  StandsListView.swift
//  Conventions
//

import SwiftUI

struct StandsListView: View {
    let stands: [Stand]
    var scrollToStandId: String? = nil
    let onExpandMapTapped: () -> Void
    let onStandTapped: (Stand) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("AppBackground")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Image("Overview")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: geometry.size.height / 3)
                        .overlay(alignment: .bottomLeading) {
                            Button(action: onExpandMapTapped) {
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

                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                if stands.isEmpty {
                                    Text("לא נמצאו דוכנים באזור זה")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                                        .padding(.top, 40)
                                } else {
                                    ForEach(stands, id: \.id) { stand in
                                        StandCardView(stand: stand, onMoreInfoTapped: { onStandTapped(stand) })
                                            .id(stand.id)
                                    }
                                }
                            }
                            .padding(16)
                        }
                        .onAppear {
                            guard let scrollToStandId else { return }
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
        Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: 1, to: 2, count: 2, list: [1, 2], raw: "1-2"), discountOrga: "TRUE", dates: [], url: "", logo: nil),
        Stand(id: "2", name: "הוצאת ספרים כלשהי", category: "מוציאים לאור", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: StandTableIds(from: 5, to: 5, count: 1, list: [5], raw: "5"), discountOrga: "FALSE", dates: [], url: "", logo: nil),
        Stand(id: "3", name: "דוכן משחקי תפקידים", category: "משחקים", area: StandArea(id: "1", title: "אולם 1"), description: "", tags: [], tableIds: nil, discountOrga: "FALSE", dates: [], url: "", logo: nil),
    ], onExpandMapTapped: {}, onStandTapped: { _ in })
}

#Preview("Empty") {
    StandsListView(stands: [], onExpandMapTapped: {}, onStandTapped: { _ in })
}
