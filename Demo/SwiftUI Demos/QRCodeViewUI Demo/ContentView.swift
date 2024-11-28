//
//  ContentView.swift
//  QRCodeViewUI Demo
//
//  Created by Darren Ford on 28/11/2024.
//

import SwiftUI
import QRCode

#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct ContentView: View {

	@State var content: String = "test"
	@State var errorCorrection: QRCode.ErrorCorrection = .quantize

	@State var foregroundColor: Color = .black
	@State var backgroundColor: Color = .white

	@State var quietSpace: Double = 0
	@State var cornerRadius: Double = 0

	@State var generatedDocument: QRCode.Document?

	@State var shadow = QRCode.Shadow.Observable()
	@State var negated = false

	@State var showImagePopover = false

	@State var image = Image(systemName: "photo")

	var body: some View {
		VStack {
			HStack(alignment: .top) {
				Form {
					Section {
						TextField("Text:", text: $content)
						Picker("Error correction:", selection: $errorCorrection) {
							Text("Low").tag(QRCode.ErrorCorrection.low)
							Text("Medium").tag(QRCode.ErrorCorrection.medium)
							Text("Quantize").tag(QRCode.ErrorCorrection.quantize)
							Text("High").tag(QRCode.ErrorCorrection.high)
						}
						Slider(value: $cornerRadius, in: 0 ... 10) {
							Text("Corner Radius:")
						}
						Slider(value: $quietSpace, in: 0 ... 6) {
							Text("Quiet space:")
						}
						Toggle("Negated:", isOn: $negated)
					}

					Section {
						ColorPicker("Foreground Color:", selection: $foregroundColor)
						ColorPicker("Background Color:", selection: $backgroundColor)
					}

					Section {
						Picker("Shadow Type:", selection: $shadow.type) {
							Text("None").tag(QRCode.Shadow.Observable.ShadowType.none)
							Text("Drop Shadow").tag(QRCode.Shadow.Observable.ShadowType.dropShadow)
							Text("Inner Shadow").tag(QRCode.Shadow.Observable.ShadowType.innerShadow)
						}
						Section {
							ColorPicker("Shadow color:", selection: $shadow.color)
							Slider(value: $shadow.offset.width, in: -1 ... 1) {
								Text("X Offset:")
							}
							Slider(value: $shadow.offset.height, in: -1 ... 1) {
								Text("Y Offset:")
							}
							Slider(value: $shadow.blur, in: 0 ... 40) {
								Text("Blur:")
							}
						}
						.disabled(shadow.type == .none)
					}
				}

				QRCodeViewUI(
					content: content,
					errorCorrection: errorCorrection,
					foregroundColor: foregroundColor.cgColor ?? CGColor(gray: 0, alpha: 1),
					backgroundColor: backgroundColor.cgColor ?? CGColor(gray: 1, alpha: 1),
					additionalQuietZonePixels: UInt(quietSpace.rounded(.towardZero)),
					backgroundFractionalCornerRadius: cornerRadius,
					negatedOnPixelsOnly: negated,
					shadow: self.shadow.generated,
					generatedDocument: $generatedDocument
				)
			}
			Button {
				guard let d = generatedDocument else { return }
				let img = try! d.cgImage(dimension: 600)
#if os(macOS)
				let i = NSImage(cgImage: img, size: .zero)
				self.image = Image(nsImage: i)
#else
				let i = UIImage(cgImage: img)
				self.image = Image(uiImage: i)
#endif
				self.showImagePopover = true
			} label: {
				Text("Generate Image")
			}
			.popover(isPresented: $showImagePopover, arrowEdge: .bottom) {
				self.image
					.resizable()
			}
		}
		.padding()
	}
}

#Preview {
    ContentView()
}


/// An observable Shadow impleemntation for use with SwiftUI
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension QRCode.Shadow {
	public struct Observable {
		/// The type of shadow
		public enum ShadowType {
			/// No shadow
			case none
			/// Drop shadow
			case dropShadow
			/// Inner shadow
			case innerShadow
		}

		/// Create
		public init() { }
		/// The type of shadow
		public var type: ShadowType = .none
		/// Shadow offset in module units
		public var offset: CGSize = .init(width: 0.1, height: -0.1)
		/// Shadow blur
		public var blur: Double = 2
		/// Shadow color
		public var color: CGColor = CGColor(gray: 0, alpha: 0.8)

		/// Generate a QRCode.Shadow
		public var generated: QRCode.Shadow? {
			switch self.type {
			case .none:
				return nil
			case .dropShadow:
				return QRCode.Shadow(.dropShadow, offset: self.offset, blur: self.blur, color: self.color)
			case .innerShadow:
				return QRCode.Shadow(.innerShadow, offset: self.offset, blur: self.blur, color: self.color)
			}
		}
	}
}
