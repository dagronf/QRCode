//
//  File.swift
//  
//
//  Created by Darren Ford on 9/11/21.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif

#if os(macOS)
import AppKit
public typealias DSFView = NSView
public typealias DSFImage = NSImage
@available(macOS 11, *)
typealias DSFViewRepresentable = NSViewRepresentable

extension NSView {
	@inlinable func setNeedsDisplay() { self.needsDisplay = true }
}
#else
import UIKit
public typealias DSFView = UIView
public typealias DSFImage = UIImage
@available(iOS 13.0, tvOS 13.0, *)
typealias DSFViewRepresentable = UIViewRepresentable
#endif
