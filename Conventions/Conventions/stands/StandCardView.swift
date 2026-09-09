//
//  StandCardView.swift
//  Conventions
//

import SwiftUI

struct StandCardView: View {
    let stand: Stand
    var showArea: Bool = false

    private var badgeText: String {
        guard showArea else { return stand.category }
        guard !stand.category.isEmpty else { return stand.area }
        return "\(stand.area), \(stand.category)"
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(stand.name)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color(uiColor: Colors.standsCardTitleColor))

            if !badgeText.isEmpty {
                Text(badgeText)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(uiColor: Colors.standsCategoryBadgeTextColor))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(uiColor: Colors.standsCategoryBadgeBackgroundColor))
                    .cornerRadius(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(uiColor: Colors.standsCardBackgroundColor))
        .cornerRadius(4)
    }
}

#Preview {
    VStack(spacing: 12) {
        StandCardView(stand: Stand(id: "1", name: "עמותת המדע הבדיוני והפנטזיה", category: "עמותות", area: "אולם 1", tableIds: nil, discountOrga: "TRUE", url: "", logo: nil))
        StandCardView(stand: Stand(id: "2", name: "אטלנטיס", category: "דוכן מסחרי", area: "א׳", tableIds: nil, discountOrga: "FALSE", url: "", logo: nil), showArea: true)
    }
    .padding(16)
}
