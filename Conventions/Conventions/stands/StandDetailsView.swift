//
//  StandDetailsView.swift
//  Conventions
//

import SwiftUI

struct StandDetailsView: View {
    let stand: Stand
    var searchText: String = ""

    private var datesLabel: String {
        stand.dates
            .compactMap { Date.parse($0, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") }
            .sorted()
            .map { "יום \($0.format("EEEEE")) \($0.format("dd.MM"))" }
            .joined(separator: ", ")
    }

    private var areaAndLocationLabel: String {
        let areaLabel = stand.area.map { $0.title } ?? ""
        let location = [stand.tableIds?.from, stand.tableIds?.to].compactMap { $0 }.joined(separator: "-")
        if areaLabel.isEmpty { return location }
        return location.isEmpty ? areaLabel : "\(areaLabel), \(location)"
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(stand.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(uiColor: Colors.standDetailsTitleColor))

            if (stand.dates.count < 3) {
                Text(datesLabel)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(uiColor: Colors.standDetailsSubtitleColor))
            }
            
            Text(areaAndLocationLabel)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(Color(uiColor: Colors.standDetailsSubtitleColor))

            if (!stand.isActive) {
                Text("לא פעיל")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(stand.isActive
                                     ? Color(uiColor: Colors.standDetailsActiveLabelColor)
                                     : Color(uiColor: Colors.standDetailsNotActiveLabelColor)
                    )
            }
            
            if (stand.isDiscountOrga) {
                Text("בדוכן זה יש הנחות לחברי העמותות המארגנות.")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(uiColor: Colors.standDetailsSubtitleColor))
            }

            Text.highlighted(
                stand.description,
                searchText: searchText,
                font: .system(size: 16, weight: .light),
                color: Color(uiColor: Colors.standDetailsDescriptionColor)
            )
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .fixedSize(horizontal: false, vertical: true)

            FlowLayout {
                Text(stand.category)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(uiColor: Colors.standTagTextColor))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(uiColor: Colors.standTagBackgroundColor))
                    .cornerRadius(10)

                ForEach(stand.tags, id: \.self) { tag in
                    Text.highlighted(
                        tag,
                        searchText: searchText,
                        font: .system(size: 14, weight: .semibold),
                        color: Color(uiColor: Colors.standTagTextColor)
                    )
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
        tableIds: StandTableIds(from: "45", to: "46", count: 2, list: ["45", "46"], raw: "45-46"),
        discountOrga: "TRUE",
        dates: ["2026-09-29T00:00:00+03:00", "2026-09-30T12:00:00+03:00"],
        url: "",
        logo: nil
    ))
}
