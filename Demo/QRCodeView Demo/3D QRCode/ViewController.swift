//
//  ViewController.swift
//  3D QRCode
//
//  Created by Darren Ford on 22/4/2024.
//

import Cocoa
import SceneKit

import QRCode

import DSFAppKitBuilder
import DSFValueBinders
import DSFMenuBuilder

class ViewController: DSFAppKitBuilderViewController {

	let qrCode = QRCode.Document(utf8String: "This is a QR code")

	let debounce = DSFDebounce(seconds: 0.05)

	let sceneView = SCNView()
	private lazy var qrText: ValueBinder<String> = ValueBinder("This is a QR code") { newValue in
		self.qrCode.utf8String = newValue
		self.update()
	}

	let allPixelStyles = ValueBinder(QRCodePixelShapeFactory.shared.all())
	private lazy var pixelSelection = ValueBinder(0) { newValue in
		let gen = self.allPixelStyles.wrappedValue[newValue]
		self.qrCode.design.shape.onPixels = gen
		self.update()
	}

	let allEyeStyles = ValueBinder(QRCodeEyeShapeFactory.shared.all())
	private lazy var eyeSelection = ValueBinder(0) { newValue in
		self.qrCode.design.shape.eye = self.allEyeStyles.wrappedValue[newValue]
		self.update()
	}

	let allPupilStyles = ValueBinder(QRCodePupilShapeFactory.shared.all())
	private lazy var pupilSelection = ValueBinder(0) { newValue in
		self.qrCode.design.shape.pupil = self.allPupilStyles.wrappedValue[newValue]
		self.update()
	}

	///

	private lazy var pixelCurveRadius = ValueBinder(1.0) { newValue in
		_ = self.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.cornerRadiusFraction)
		self.update()
	}
	private var pixelCurveRadiusEnabled = ValueBinder(false)

	private lazy var pixelInnerCurves = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.hasInnerCorners)
		self.update()
	}
	private var pixelInnerCurvesEnabled = ValueBinder(false)

	///

	private lazy var pixelInset = ValueBinder(1.0) { newValue in
		_ = self.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.insetFraction)
		self.update()
	}
	private var pixelInsetEnabled = ValueBinder(false)

	private lazy var pixelRandomInset = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.useRandomInset)
		self.update()
	}
	private var pixelRandomInsetEnabled = ValueBinder(false)

	///

	private lazy var pixelRotation = ValueBinder(1.0) { newValue in
		_ = self.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.rotationFraction)
		self.update()
	}
	private var pixelRotationEnabled = ValueBinder(false)

	private lazy var pixelRandomRotation = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.onPixels.setSettingValue(newValue, forKey: QRCode.SettingsKey.useRandomRotation)
		self.update()
	}
	private var pixelRandomRotationEnabled = ValueBinder(false)

	///

	private lazy var quietSpacePixels = ValueBinder(0.0) { newValue in
		_ = self.qrCode.design.additionalQuietZonePixels = UInt(newValue)
		self.update()
	}

	///

	private lazy var negatePixels = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.negatedOnPixelsOnly = newValue
		self.update()
	}

	///

	private lazy var eyeCornerRadius = ValueBinder(0.65) { newValue in
		_ = self.qrCode.design.shape.eye.setSettingValue(newValue, forKey: QRCode.SettingsKey.cornerRadiusFraction)
		self.update()
	}
	private var eyeCornerRadiusEnabled = ValueBinder(false)

	private lazy var eyeFlipped = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.eye.setSettingValue(newValue, forKey: QRCode.SettingsKey.isFlipped)
		self.update()
	}
	private var eyeFlippedEnabled = ValueBinder(false)

	private lazy var eyeSelectedCorners = ValueBinder(NSSet()) { newValue in
		var value: Int = 0
		if newValue.contains(0) { value += QRCode.Corners.tl.rawValue }
		if newValue.contains(1) { value += QRCode.Corners.tr.rawValue }
		if newValue.contains(2) { value += QRCode.Corners.bl.rawValue }
		if newValue.contains(3) { value += QRCode.Corners.br.rawValue }

		_ = self.qrCode.design.shape.eye.setSettingValue(value, forKey: QRCode.SettingsKey.corners)
		self.update()
	}
	private var eyeSelectedCornersEnabled = ValueBinder(false)

	///

	private lazy var pupilFlipped = ValueBinder(false) { newValue in
		_ = self.qrCode.design.shape.pupil?.setSettingValue(newValue, forKey: QRCode.SettingsKey.isFlipped)
		self.update()
	}
	private var pupilFlippedEnabled = ValueBinder(false)

	private lazy var pupilSelectedCorners = ValueBinder(NSSet()) { newValue in
		var value: Int = 0
		if newValue.contains(0) { value += QRCode.Corners.tl.rawValue }
		if newValue.contains(1) { value += QRCode.Corners.tr.rawValue }
		if newValue.contains(2) { value += QRCode.Corners.bl.rawValue }
		if newValue.contains(3) { value += QRCode.Corners.br.rawValue }

		_ = self.qrCode.design.shape.pupil?.setSettingValue(value, forKey: QRCode.SettingsKey.corners)
		self.update()
	}
	private var pupilSelectedCornersEnabled = ValueBinder(false)


	///

	override func viewWillAppear() {
		super.viewWillAppear()

		self.setupScene()
		self.update()
	}

	override var viewBody: Element {
		VStack {
			HStack(spacing: 0) {
				View(sceneView)
					.minWidth(300)
					.minHeight(300)

				VStack {

					Box("QR Code settings") {
						VStack {
							HStack {
								Label("Text:").font(.headline)
								TextField(qrText)
							}
							HStack {
								Label("Quiet space:").font(.headline)
								Slider(quietSpacePixels, range: 0.0 ... 10.0)
									.controlSize(.small)
									.numberOfTickMarks(9, allowsTickMarkValuesOnly: true)
									.horizontalCompressionResistancePriority(.defaultHigh)
							}
							HStack {
								Label("Negate:").font(.headline)
								Toggle()
									.controlSize(.small)
									.bindOnOff(negatePixels)
								EmptyView()
							}
						}
					}
					.width(310)

					ScrollView(borderType: .noBorder) {
						VStack {
							FakeBox("Pixel Styles") {
								
								Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allPixelStyles.wrappedValue, { item in
									let image = QRCodePixelShapeFactory.shared.image(
										pixelGenerator: item,
										dimension: 120,
										foregroundColor: NSColor.textColor.cgColor
									)!
									return Button(image: NSImage(cgImage: image, size: .init(width: 60, height: 60))) { [weak self] _ in
										guard let `self` = self else { return }
										self.qrCode.design.shape.onPixels = item
										self.sync(.pixels)
										self.update()
									}
									.isBordered(false)
									.toolTip(item.title)
								}))

								HDivider()

								HStack {
									Label("radius:").font(.callout.bold())
									Slider(pixelCurveRadius, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(pixelCurveRadiusEnabled)
									Label("inner:").font(.callout.bold())
									Toggle()
										.controlSize(.small)
										.bindOnOff(pixelInnerCurves)
										.bindIsEnabled(pixelInnerCurvesEnabled)
								}
								HStack {
									Label("inset:").font(.callout.bold())
									Slider(pixelInset, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(pixelInsetEnabled)
									Label("rnd:").font(.callout.bold())
									Toggle()
										.controlSize(.small)
										.bindOnOff(pixelRandomInset)
										.bindIsEnabled(pixelRandomInsetEnabled)
								}
								HStack {
									Label("rotation:").font(.callout.bold())
									Slider(pixelRotation, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(pixelRotationEnabled)
									Label("rnd:").font(.callout.bold())
									Toggle()
										.controlSize(.small)
										.bindOnOff(pixelRandomRotation)
										.bindIsEnabled(pixelRandomRotationEnabled)
								}
							}

							FakeBox("Eye Styles") {

								Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allEyeStyles.wrappedValue, { item in
									let image = QRCodeEyeShapeFactory.shared.image(
										eyeGenerator: item,
										dimension: 96,
										foregroundColor: NSColor.textColor.cgColor
									)!
									return Button(image: NSImage(cgImage: image, size: .init(width: 48, height: 48))) { [weak self] _ in
										guard let `self` = self else { return }
										self.qrCode.design.shape.eye = item
										self.qrCode.design.shape.pupil = nil
										self.sync(.eye)
										self.update()
									}
									.isBordered(false)
									.toolTip(item.title)
								}))

								HDivider()

								HStack {
									Label("radius:").font(.callout.bold())
									Slider(eyeCornerRadius, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(eyeCornerRadiusEnabled)
								}
								HStack {
									Label("flipped:").font(.callout.bold())
									Toggle()
										.controlSize(.small)
										.bindOnOff(eyeFlipped)
										.bindIsEnabled(eyeFlippedEnabled)
								}

								HStack {
									Label("corners:").font(.callout.bold())
									Segmented(trackingMode: .selectAny) {
										Segment("􀰼")
										Segment("􀄔")
										Segment("􀄖")
										Segment("􀄘")
									}
									.controlSize(.small)
									.bindSelectedSegments(eyeSelectedCorners)
									.bindIsEnabled(eyeSelectedCornersEnabled)
									.horizontalHuggingPriority(.init(10))
									EmptyView()
								}
							}

							FakeBox("Pupil Styles") {

								Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allPupilStyles.wrappedValue, { item in
									let image = QRCodePupilShapeFactory.shared.image(
										pupilGenerator: item,
										dimension: 80,
										foregroundColor: NSColor.textColor.cgColor
									)!
									return Button(image: NSImage(cgImage: image, size: .init(width: 40, height: 40))) { [weak self] _ in
										guard let `self` = self else { return }
										self.qrCode.design.shape.pupil = item
										self.sync(.pupil)
										self.update()
									}
									.isBordered(false)
									.toolTip(item.title)
								}))

								HDivider()

								HStack {
									Label("flipped:").font(.callout.bold())
									Toggle()
										.controlSize(.small)
										.bindOnOff(pupilFlipped)
										.bindIsEnabled(pupilFlippedEnabled)
								}

								HStack {
									Label("corners:").font(.callout.bold())
									Segmented(trackingMode: .selectAny) {
										Segment("􀰼")
										Segment("􀄔")
										Segment("􀄖")
										Segment("􀄘")
									}
									.controlSize(.small)
									.bindSelectedSegments(pupilSelectedCorners)
									.bindIsEnabled(pupilSelectedCornersEnabled)
									EmptyView()
								}
							}
						}
					}

					HDivider()

					Button(title: "Reset") { [weak self] _ in
						guard let `self` = self else { return }
						self.qrCode.design.shape.onPixels = QRCode.PixelShape.Square()
						self.qrCode.design.shape.eye = QRCode.EyeShape.Square()
						self.qrCode.design.shape.pupil = nil
						self.sync(.all)
						self.update()
					}
				}
				.edgeInsets(12)
				.width(340)
			}

		}
		.padding(8)
	}

	struct SyncType: OptionSet {
		let rawValue: Int

		static let pixels = SyncType(rawValue: 1 << 0)
		static let eye = SyncType(rawValue: 1 << 1)
		static let pupil = SyncType(rawValue: 1 << 2)

		static let all: SyncType = [.pixels, .eye, .pupil]
	}


	private func sync(_ syncType: SyncType) {
		if syncType.contains(.pixels) {
			let item = qrCode.design.shape.onPixels
			self.pixelCurveRadiusEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction)
			self.pixelCurveRadius.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.cornerRadiusFraction) ?? 0.6
			self.pixelInnerCurves.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.hasInnerCorners) ?? false
			self.pixelInnerCurvesEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.hasInnerCorners)

			self.pixelInsetEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.insetFraction)
			self.pixelInset.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.insetFraction) ?? 0.1
			self.pixelRandomInset.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.useRandomInset) ?? false
			self.pixelRandomInsetEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.useRandomInset)

			self.pixelRotationEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.rotationFraction)
			self.pixelRotation.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.rotationFraction) ?? 0.0
			self.pixelRandomRotation.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.useRandomRotation) ?? false
			self.pixelRandomRotationEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.useRandomRotation)
		}

		if syncType.contains(.eye) {
			let item = qrCode.design.shape.eye
			self.eyeCornerRadiusEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.cornerRadiusFraction)
			self.eyeCornerRadius.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.cornerRadiusFraction) ?? 0.65

			self.eyeFlippedEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped)
			self.eyeFlipped.wrappedValue = item.settingsValue(for: QRCode.SettingsKey.isFlipped) ?? false

			self.eyeSelectedCornersEnabled.wrappedValue = item.supportsSettingValue(forKey: QRCode.SettingsKey.corners)
			if let value: Int = item.settingsValue(for: QRCode.SettingsKey.corners) {
				let opts = QRCode.Corners(rawValue: value)
				let s = NSMutableSet()
				if opts.contains(.tl) { s.add(0) }
				if opts.contains(.tr) { s.add(1) }
				if opts.contains(.bl) { s.add(2) }
				if opts.contains(.br) { s.add(3) }
				self.eyeSelectedCorners.wrappedValue = s
			}
			else {
				self.eyeSelectedCorners.wrappedValue = NSSet()
			}
		}

		if syncType.contains(.pupil) {
			let item = qrCode.design.shape.pupil
			self.pupilFlippedEnabled.wrappedValue = item?.supportsSettingValue(forKey: QRCode.SettingsKey.isFlipped) ?? false
			self.pupilFlipped.wrappedValue = item?.settingsValue(for: QRCode.SettingsKey.isFlipped) ?? false

			self.pupilSelectedCornersEnabled.wrappedValue = item?.supportsSettingValue(forKey: QRCode.SettingsKey.corners) ?? false
			if let value: Int = item?.settingsValue(for: QRCode.SettingsKey.corners) {
				let opts = QRCode.Corners(rawValue: value)
				let s = NSMutableSet()
				if opts.contains(.tl) { s.add(0) }
				if opts.contains(.tr) { s.add(1) }
				if opts.contains(.bl) { s.add(2) }
				if opts.contains(.br) { s.add(3) }
				self.pupilSelectedCorners.wrappedValue = s
			}
			else {
				self.pupilSelectedCorners.wrappedValue = NSSet()
			}
		}
	}

	private func update() {
		debounce.debounce { [weak self] in
			self?._update()
		}
	}

	private func _update() {
		let path = qrCode.path(CGSize(width: 1000, height: 1000))
		let mx = CGMutablePath()
		mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
		qrCodeShape?.path = NSBezierPath(cgPath: mx)
	}

	var qrCodeShape: SCNShape?

	func setupScene() {
		qrCode.design.shape.onPixels = QRCode.PixelShape.Square()
		qrCode.design.shape.eye = QRCode.EyeShape.Square()

		let path = qrCode.path(CGSize(width: 1000, height: 1000))
		let mx = CGMutablePath()
		mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
		let p = NSBezierPath(cgPath: mx)
		let shape = SCNShape(path: p, extrusionDepth: 20)
		self.qrCodeShape = shape

		let scene = SCNScene()
		scene.background.contents = NSColor.black
		sceneView.scene = scene
		sceneView.allowsCameraControl = true
		sceneView.translatesAutoresizingMaskIntoConstraints = false

		let cameraNode = SCNNode()
		let camera = SCNCamera()
		camera.usesOrthographicProjection = false
		camera.zFar = 10000
		cameraNode.camera = camera
		cameraNode.position = SCNVector3(x: 0, y: 0, z: 1500)
		scene.rootNode.addChildNode(cameraNode)


		let material = SCNMaterial()
		material.isDoubleSided = true
		material.shininess = 1

//		let bmp = try! CGImage.makeImage(dimension: 500) { ctx in
//			let gradient = try! DSFGradient.build([
//				(0.30, CGColor(srgbRed: 0.005, green: 0.101, blue: 0.395, alpha: 1)),
//				(0.55, CGColor(srgbRed: 0, green: 0.021, blue: 0.137, alpha: 1)),
//				(0.655, CGColor(srgbRed: 0, green: 0.978, blue: 0.354, alpha: 1)),
//				(0.66, CGColor(srgbRed: 1, green: 0.248, blue:0, alpha: 1)),
//				(1.00, CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)),
//			])
//
//			let linear = QRCode.FillStyle.LinearGradient(
//				gradient,
//				startPoint: CGPoint(x: 0.2, y: 0),
//				endPoint: CGPoint(x: 1, y: 1)
//			)
//			linear.fill(ctx: ctx, rect: CGRect(origin: .zero, size: .init(width: 500, height: 500)))
//		}
//		material.diffuse.contents = bmp

		//material.diffuse.contents = NSColor.white
		shape.insertMaterial(material, at: 0)
		let n = SCNNode(geometry: shape)

		n.position = SCNVector3(x: -500, y: -500, z: 0)

		scene.rootNode.addChildNode(n)

		do {
			let plane = SCNPlane(width: 1000, height: 1000)
			plane.cornerRadius = 0
			let planeNode = SCNNode(geometry: plane)
			planeNode.position = .init(x: 0, y: 0, z: -9.5)

			let material = SCNMaterial()
			material.isDoubleSided = true
			if #available(macOS 10.15, *) {
				material.diffuse.contents = NSColor.systemIndigo
			} else {
				material.diffuse.contents = NSColor.systemPurple
			}
			plane.insertMaterial(material, at: 0)

			scene.rootNode.addChildNode(planeNode)
		}


		do {
			let light = SCNLight()
			light.type = .omni
			light.intensity = 5000
			let lightNode = SCNNode()
			lightNode.light = light
			lightNode.position = SCNVector3(x: 500, y: 500, z: 100)
			scene.rootNode.addChildNode(lightNode)
		}

		do {
			let light = SCNLight()
			light.type = .omni
			light.intensity = 5000
			light.color = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 1)
			let lightNode = SCNNode()
			lightNode.light = light
			lightNode.position = SCNVector3(x: -500, y: -500, z: 100)
			scene.rootNode.addChildNode(lightNode)
		}

		do {
			let light = SCNLight()
			light.type = .omni
			light.intensity = 5000
			light.color = NSColor(calibratedRed: 0, green: 0, blue: 1, alpha: 1)
			let lightNode = SCNNode()
			lightNode.light = light
			lightNode.position = SCNVector3(x: 0, y: 0, z: -400)
			scene.rootNode.addChildNode(lightNode)
		}

		self.sceneView.scene = scene

		self.sync(.all)
		self.update()
	}
}
