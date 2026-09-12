//
//  StandDetailsView.swift
//  Conventions
//

import SwiftUI

struct StandDetailsView: View {
    let stand: Stand

    private var datesLabel: String {
        stand.dates
            .compactMap { Date.parse($0, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") }
            .sorted()
            .map { "יום \($0.format("EEEEE")) \($0.format("dd.MM"))" }
            .joined(separator: ", ")
    }

    private var areaAndLocationLabel: String {
        let areaLabel = stand.area.map { $0.title != $0.id ? "\($0.id) - \($0.title)" : $0.title } ?? ""
        let location = stand.tableIds?.raw ?? ""
        if areaLabel.isEmpty { return location }
        return location.isEmpty ? areaLabel : "\(areaLabel), \(location)"
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(stand.name)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(uiColor: Colors.textColor))

            Text(datesLabel)
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: Colors.standDetailsSubtitleColor))

            Text(areaAndLocationLabel)
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: Colors.standDetailsSubtitleColor))

            Text(stand.isActive ? "פעיל" : "לא פעיל")
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: Colors.standDetailsActiveLabelColor))

            Text(stand.description)
                .font(.system(size: 16))
                .foregroundColor(Color(uiColor: Colors.standDetailsDescriptionColor))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true)

            FlowLayout {
                ForEach(stand.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: Colors.standTagTextColor))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(uiColor: Colors.standTagBackgroundColor))
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(uiColor: Colors.white).ignoresSafeArea())
    }
}

#Preview {
    StandDetailsView(stand: Stand(
        id: "1",
        name: "עמותת המדע הבדיוני והפנטזיה",
        category: "עמותות",
        area: StandArea(id: "ג", title: "גאליפריי"),
        description: "עמותה לקידום המדע הבדיוני והפנטזיה בישראל, מקיימת אירועים ופעילויות לאורך כל השנה.",
        tags: ["ספרים", "משחקים", "קוסטיום", "אמנות", "מתנות"],
        tableIds: StandTableIds(from: 45, to: 46, count: 2, list: [45, 46], raw: "45-46"),
        discountOrga: "TRUE",
        dates: ["2026-09-29T00:00:00+03:00", "2026-09-30T00:00:00+03:00"],
        url: "",
        logo: nil
    ))
}
