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

class Observable<CoreType: AnyObject> {
	var object: CoreType
	var observers: [(CoreType) -> Void] = []

	init(_ object: CoreType) {
		self.object = object
	}

	func register(_ block: @escaping (CoreType) -> Void) {
		self.observers.append(block)
	}

	func markObjectChanged() {
		observers.forEach { $0(self.object) }
	}
}

class CustomButtonCell: NSButtonCell {
	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
		let path = NSBezierPath(roundedRect: frame, xRadius: 4, yRadius: 4)
		if state == .on {
			let fillColor: NSColor
			if #available(macOS 10.14, *) {
				fillColor = NSColor.controlAccentColor
			} else {
				fillColor = NSColor.selectedTextBackgroundColor
			}
			fillColor.setFill()
			path.fill()
		}
	}
}

class ViewController: DSFAppKitBuilderViewController {

	let qrCode = QRCode.Document(utf8String: "This is a QR code")
	private lazy var qrCodeObject = Observable(self.qrCode)

	let debounce = DSFDebounce(seconds: 0.05)
	let sceneView = SCNView()

	override func viewWillAppear() {
		super.viewWillAppear()

		self.setupScene()
		self.updateDisplay()
	}

	override var viewBody: Element {
		SplitView(isVertical: true) {
			SplitViewItem {
				View(sceneView)
					.minWidth(300)
					.minHeight(300)
			}

			SplitViewItem {
				VStack {

					FakeBox("QR Code settings") {
						CommonSettingsView(qrCode: self.qrCodeObject) { [weak self] in
							self?.updateDisplay()
						}
					}

					ScrollView(borderType: .noBorder, fitHorizontally: true) {
						VStack(spacing: 8) {
							FakeBox("Pixel Styles") {
								PixelStylesView(qrCode: self.qrCodeObject) { [weak self] in
									self?.updateDisplay()
								}
							}

							FakeBox("Eye Styles") {
								EyeStylesView(qrCode: self.qrCodeObject) { [weak self] in
									self?.updateDisplay()
								}
							}

							FakeBox("Pupil Styles") {
								PupilStylesView(qrCode: self.qrCodeObject) { [weak self] in
									self?.updateDisplay()
								}
							}
						}
					}

					HDivider()

					Button(title: "Reset") { [weak self] _ in
						self?.reset()
					}
				}
				.edgeInsets(left: 12)
				.width(360)
			}
		}
		.padding(8)
	}

	func reset() {
		self.qrCode.errorCorrection = .high
		self.qrCode.design = QRCode.Design()
		self.qrCodeObject.markObjectChanged()

		self.updateDisplay()
	}

	private func updateDisplay() {
		debounce.debounce { [weak self] in
			self?._updateDisplay()
		}
	}

	private func _updateDisplay() {
		let path = qrCode.path(CGSize(width: 1000, height: 1000))
		let mx = CGMutablePath()
		mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
		qrCodeShape?.path = NSBezierPath(cgPath: mx)
		qrBackgroundPlane?.cornerRadius = qrCode.design.style.backgroundFractionalCornerRadius * 1000
	}

	var qrCodeShape: SCNShape?
	var qrBackgroundPlane: SCNPlane?

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
		cameraNode.position = SCNVector3(x: 0, y: 0, z: 1300)
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
			self.qrBackgroundPlane = plane
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

		//self.sync(.all)
		self.updateDisplay()
	}
}
