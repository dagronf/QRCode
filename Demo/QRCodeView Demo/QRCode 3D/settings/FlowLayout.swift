//
//  FlowLayout.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI

struct FlowLayout: Layout {
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
		
		var totalHeight: CGFloat = 0
		var totalWidth: CGFloat = 0
		
		var lineWidth: CGFloat = 0
		var lineHeight: CGFloat = 0
		
		for size in sizes {
			if lineWidth + size.width > proposal.width ?? 0 {
				totalHeight += lineHeight
				lineWidth = size.width
				lineHeight = size.height
			} else {
				lineWidth += size.width
				lineHeight = max(lineHeight, size.height)
			}
			
			totalWidth = max(totalWidth, lineWidth)
		}
		
		totalHeight += lineHeight
		
		return .init(width: totalWidth, height: totalHeight)
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
		
		var lineX = bounds.minX
		var lineY = bounds.minY
		var lineHeight: CGFloat = 0
		
		for index in subviews.indices {
			if lineX + sizes[index].width > (proposal.width ?? 0) {
				lineY += lineHeight
				lineHeight = 0
				lineX = bounds.minX
			}
			
			subviews[index].place(
				at: .init(
					x: lineX + sizes[index].width / 2,
					y: lineY + sizes[index].height / 2
				),
				anchor: .center,
				proposal: ProposedViewSize(sizes[index])
			)
			
			lineHeight = max(lineHeight, sizes[index].height)
			lineX += sizes[index].width
		}
	}
}
