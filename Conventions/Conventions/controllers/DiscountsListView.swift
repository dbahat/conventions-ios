//
//  DiscountsListView.swift
//  Conventions
//

import SwiftUI
import UIKit

struct DiscountItem: Identifiable {
    let id = UUID()
    var text: String
    var image: UIImage?
    var linkText: String?
    var linkUrl: String?
    var title: Bool?
}

struct DiscountsListView: View {
    let items: [DiscountItem]

    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(items) { item in
                        DiscountItemRow(item: item)
                    }
                }
                .padding(8)
            }
            .background(Color(uiColor: Colors.staticHtmlContentColor))
            .padding(.horizontal, 15)
            .padding(.top, 8)
        }
    }
}

private struct DiscountItemRow: View {
    let item: DiscountItem

    var body: some View {
        VStack(spacing: 12) {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: image.size.height)
            }
            
            if let linkText = item.linkText, let linkUrl = item.linkUrl, let url = URL(string: linkUrl) {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    Text(linkText)
                        .foregroundColor(Color(uiColor: Colors.linksColor))
                        .frame(height: 30)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            if item.title == true {
                Text(item.text)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(Color(uiColor: Colors.textColor))
                    .multilineTextAlignment(.center)
            } else if let attributedText = item.text.htmlAttributedString().map(AttributedString.init) {
                Text(attributedText)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    DiscountsListView(items: [
        DiscountItem(text: "העסקים הבאים מעניקים הנחה במהלך שלושת ימי הפסטיבל:", title: true),
        DiscountItem(text: "<br/>10% הנחה באתר על כל המועמדים לפרס גפן", linkText: "עברית", linkUrl: "https://www.e-vrit.co.il/"),
    ])
}
