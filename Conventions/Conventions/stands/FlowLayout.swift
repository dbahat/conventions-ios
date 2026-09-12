//
//  FlowLayout.swift
//  Conventions
//

import SwiftUI

// Wraps its children onto multiple rows, packed from the right edge (this app's forced-LTR
// layout means Layout's automatic RTL mirroring never kicks in, so rows are packed
// right-to-left explicitly here, not left as a system default).
struct FlowLayout: Layout {
    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = computeRows(maxWidth: maxWidth, subviews: subviews)
        let height = rows.map(\.height).reduce(0, +) + verticalSpacing * CGFloat(max(rows.count - 1, 0))
        return CGSize(width: proposal.width ?? (rows.map(\.width).max() ?? 0), height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let rows = computeRows(maxWidth: bounds.width, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.maxX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                x -= size.width
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x -= horizontalSpacing
            }
            y += row.height + verticalSpacing
        }
    }

    private struct Row {
        var indices: [Int]
        var width: CGFloat
        var height: CGFloat
    }

    private func computeRows(maxWidth: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let candidateWidth = indices.isEmpty ? size.width : width + horizontalSpacing + size.width
            if candidateWidth > maxWidth, !indices.isEmpty {
                rows.append(Row(indices: indices, width: width, height: height))
                indices = []
                width = 0
                height = 0
            }
            width = indices.isEmpty ? size.width : width + horizontalSpacing + size.width
            height = max(height, size.height)
            indices.append(index)
        }
        if !indices.isEmpty {
            rows.append(Row(indices: indices, width: width, height: height))
        }
        return rows
    }
}
