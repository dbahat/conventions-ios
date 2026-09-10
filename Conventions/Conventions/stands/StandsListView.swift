//
//  StandsListView.swift
//  Conventions
//

import SwiftUI

struct StandsListView: View {
    let stands: [Stand]
    let onExpandMapTapped: () -> Void

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
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color(uiColor: Colors.colorAccent)))
                                    .shadow(radius: 3)
                            }
                            .padding(12)
                        }

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if stands.isEmpty {
                                Text("לא נמצאו דוכנים באזור זה")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(uiColor: Colors.standsCardSubtitleColor))
                                    .padding(.top, 40)
                            } else {
                                ForEach(stands, id: \.id) { stand in
                                    StandCardView(stand: stand)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
    }
}

#Preview {
    StandsListView(stands: [
        Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: "אולם 1", tableIds: StandTableIds(from: 1, to: 2, count: 2, raw: "1-2"), discountOrga: "TRUE", url: "", logo: nil),
        Stand(id: "2", name: "הוצאת ספרים כלשהי", category: "מוציאים לאור", area: "אולם 1", tableIds: StandTableIds(from: 5, to: 5, count: 1, raw: "5"), discountOrga: "FALSE", url: "", logo: nil),
        Stand(id: "3", name: "דוכן משחקי תפקידים", category: "משחקים", area: "אולם 1", tableIds: nil, discountOrga: "FALSE", url: "", logo: nil),
    ], onExpandMapTapped: {})
}

#Preview("Empty") {
    StandsListView(stands: [], onExpandMapTapped: {})
}
