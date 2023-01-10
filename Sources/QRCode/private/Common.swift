//
//  Common.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif

#if os(macOS)
import AppKit
public typealias DSFView = NSView
public typealias DSFImage = NSImage
@available(macOS 10.15, *)
typealias DSFViewRepresentable = NSViewRepresentable

extension NSView {
	@inlinable func setNeedsDisplay() { self.needsDisplay = true }
}
#elseif os(watchOS)
import UIKit
public typealias DSFImage = UIImage
#else
import UIKit
public typealias DSFView = UIView
public typealias DSFImage = UIImage
@available(iOS 13.0, tvOS 13.0, *)
typealias DSFViewRepresentable = UIViewRepresentable
#endif

#if !os(macOS)
extension UIImage {
	func pngRepresentation() -> Data? { self.pngData() }
}
#endif
