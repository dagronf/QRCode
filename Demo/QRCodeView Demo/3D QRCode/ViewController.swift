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

	let debounce = DSFDebounce(seconds: 0.2)

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

	override func viewWillAppear() {
		super.viewWillAppear()

		self.setupScene()
		self.update()
	}

	override var viewBody: Element {
		VStack {
			HStack(spacing: 0) {
				View(sceneView)

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
							}
						}
					}
					.width(280)

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

										self.update()
									}
									.isBordered(false)
									.toolTip(item.title)
								}))

								HDivider()

								HStack {
									Label("radius")
									Slider(pixelCurveRadius, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(pixelCurveRadiusEnabled)
									Label("inner")
									Toggle()
										.controlSize(.small)
										.bindOnOff(pixelInnerCurves)
										.bindIsEnabled(pixelInnerCurvesEnabled)
								}
								HStack {
									Label("inset")
									Slider(pixelInset, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(pixelInsetEnabled)
									Label("random")
									Toggle()
										.controlSize(.small)
										.bindOnOff(pixelRandomInset)
										.bindIsEnabled(pixelRandomInsetEnabled)
								}
								HStack {
									Label("rotation")
									Slider(pixelRotation, range: 0 ... 1)
										.controlSize(.small)
										.bindIsEnabled(pixelRotationEnabled)
									Label("random")
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
										dimension: 80,
										foregroundColor: NSColor.textColor.cgColor
									)!
									return Button(image: NSImage(cgImage: image, size: .init(width: 40, height: 40))) { [weak self] _ in
										self?.qrCode.design.shape.eye = item
										self?.update()
									}
									.isBordered(false)
									.toolTip(item.title)
								}))
							}

							FakeBox("Pupil Styles") {

								Flow(minimumInteritemSpacing: 1, minimumLineSpacing: 1, ForEach(allPupilStyles.wrappedValue, { item in
									let image = QRCodePupilShapeFactory.shared.image(
										pupilGenerator: item,
										dimension: 80,
										foregroundColor: NSColor.textColor.cgColor
									)!
									return Button(image: NSImage(cgImage: image, size: .init(width: 40, height: 40))) { [weak self] _ in
										self?.qrCode.design.shape.pupil = item
										self?.update()
									}
									.isBordered(false)
									.toolTip(item.title)
								}))
							}
						}
					}
				}
				.edgeInsets(12)
				.width(300)
			}

		}
		.padding(8)
	}

	private func update() {
		debounce.debounce { [weak self] in
			self?.update2()
		}
	}

	private func update2() {
		let path = qrCode.path(CGSize(width: 1000, height: 1000))
		let mx = CGMutablePath()
		mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
		qrCodeShape?.path = NSBezierPath(cgPath: mx)
	}

	var qrCodeShape: SCNShape?

	func setupScene() {

		qrCode.design.shape.eye = QRCode.EyeShape.Peacock()
		qrCode.design.shape.onPixels = QRCode.PixelShape.RoundedPath()

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
		material.diffuse.contents = NSColor.white
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
			material.diffuse.contents = NSColor.systemIndigo
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
	}
}


func ForEach<T>(_ items: [T], _ block: (T) -> Element) -> [Element] {
	items.map { block($0) }
}


public class DSFDebounce {

	// MARK: - Properties
	private let queue = DispatchQueue.main
	private var workItem = DispatchWorkItem(block: {})
	private var interval: TimeInterval

	// MARK: - Initializer
	init(seconds: TimeInterval) {
		self.interval = seconds
	}

	// MARK: - Debouncing function
	func debounce(action: @escaping (() -> Void)) {
		workItem.cancel()
		workItem = DispatchWorkItem(block: { action() })
		queue.asyncAfter(deadline: .now() + interval, execute: workItem)
	}
}
