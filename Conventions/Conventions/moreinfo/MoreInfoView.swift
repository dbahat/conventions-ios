//
//  MoreInfoView.swift
//  Conventions
//
//  Created by David Bahat on 9/5/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import SwiftUI

struct MoreInfoRow: Identifiable {
    let id = UUID()
    let name: String
    let imageId: String
    let action: () -> Void
}

struct MoreInfoView: View {
    let rows: [MoreInfoRow]

    var body: some View {
        ZStack {
            Image("HomeBackground")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ForEach(rows) { row in
                    MoreInfoRowView(row: row)
                }
                Spacer(minLength: 0)
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

private struct MoreInfoRowView: View {
    let row: MoreInfoRow

    var body: some View {
        Button(action: row.action) {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Spacer(minLength: 0)
                    Text(row.name)
                        .font(.system(size: 17))
                        .foregroundColor(Color(uiColor: Colors.homeTextColor))
                    Image(row.imageId)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(uiColor: Colors.homeTextColor))
                }
                .padding(.trailing, 8)
                .frame(height: 51)

                Rectangle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
