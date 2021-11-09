//
//  NSUIView+Snapshot.swift
//  
//
//  Created by Darren Ford on 12/2/21.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

#if os(macOS)
public extension NSView {
	@objc func snapshot() -> NSImage? {
		guard let bitmapRep = self.bitmapImageRepForCachingDisplay(in: self.bounds) else { return nil }
		self.cacheDisplay(in: self.bounds, to: bitmapRep)
		let image = NSImage()
		image.addRepresentation(bitmapRep)
		return image
	}
}
#else

public extension UIView {
	@objc func snapshot() -> UIImage {
		if #available(iOS 10.0, tvOS 10.0, *) {
			let renderer = UIGraphicsImageRenderer(bounds: bounds)
			return renderer.image { rendererContext in
				layer.render(in: rendererContext.cgContext)
			}
		} else {
			UIGraphicsBeginImageContext(self.frame.size)
			self.layer.render(in:UIGraphicsGetCurrentContext()!)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return UIImage(cgImage: image!.cgImage!)
		}
	}
}
#endif
