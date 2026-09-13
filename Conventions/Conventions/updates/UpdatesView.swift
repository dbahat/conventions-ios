//
//  UpdatesView.swift
//  Conventions
//

import SwiftUI

struct UpdatesView: View {
    var onRefresh: () async -> Bool

    @State private var updates: [Update] = []
    @State private var hasRequestedInitialRefresh = false

    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            if updates.isEmpty {
                Text("לא נמצאו עדכונים")
                    .font(.system(size: 22))
                    .foregroundColor(Color(uiColor: Colors.hintTextColor))
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(updates, id: \.id) { update in
                            UpdateRowView(update: update)
                        }
                    }
                    .padding(8)
                }
                .refreshable {
                    _ = await onRefresh()
                    updates = Convention.instance.updates.getAll()
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
            updates = Convention.instance.updates.getAll()

            if !hasRequestedInitialRefresh {
                hasRequestedInitialRefresh = true
                Convention.instance.updates.refresh { _ in
                    DispatchQueue.main.async {
                        updates = Convention.instance.updates.getAll()
                    }
                }
            }
        }
    }
}

private struct UpdateRowView: View {
    let update: Update

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                if update.isNew {
                    Text("חדש")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color(uiColor: Colors.newUpdateLabelBackgroundColor))
                        .cornerRadius(10)
                }

                Spacer(minLength: 0)

                Text(update.date.format("HH:mm"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(update.isNew ? Color(uiColor: Colors.updateTimeTextColor) : Color(uiColor: Colors.textColor))
                    .background(Color(uiColor: Colors.updateTimeBackground))
                
                Text(update.date.format("dd.MM.yyyy"))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(update.isNew ? Color(uiColor: Colors.updateTimeTextColor) : Color(uiColor: Colors.textColor))
                    .background(Color(uiColor: Colors.updateTimeBackground))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)

            Text(update.text)
                .font(.system(size: 16))
                .foregroundColor(Color(uiColor: Colors.updateTextColor))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 10)
        }
        .padding(.vertical, 8)
        .background(Color(uiColor: Colors.updateBackgroundColor))
        .cornerRadius(8)
    }
}

private func dummyUpdate(id: String, text: String, date: Date, isNew: Bool) -> Update {
    let update = Update(id: id, text: text, date: date, category: "general")
    update.isNew = isNew
    return update
}

#Preview("cards-only") {
    let date = Date.from(year: 2026, month: 09, day: 29, hour: 13, minute: 35)
    ScrollView {
        VStack(spacing: 8) {
            UpdateRowView(update: dummyUpdate(id: "1", text: "עדכון קצר וחדש", date: date, isNew: true))
            UpdateRowView(update: dummyUpdate(id: "2", text: "עדכון קצר שכבר נקרא", date: date.addingTimeInterval(-3600), isNew: false))
            UpdateRowView(update: dummyUpdate(
                id: "3",
                text: "עדכון עם טקסט ארוך במיוחד, שנועד לבדוק כיצד הכרטיס מתנהג כשיש הרבה תוכן טקסטואלי שצריך להיכנס לכמה שורות ולא רק לשורה אחת קצרה",
                date: date.addingTimeInterval(-7200),
                isNew: true
            ))
        }
        .padding(8)
    }
}

#Preview("sceen") {
    UpdatesView(onRefresh: { true })
}
