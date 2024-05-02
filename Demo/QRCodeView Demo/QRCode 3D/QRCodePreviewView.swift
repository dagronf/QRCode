//
//  3DSceneView.swift
//  QRCode 3D
//
//  Created by Darren Ford on 25/4/2024.
//

import SwiftUI
import SceneKit

import QRCode

#if os(macOS)
struct QRCodePreviewView: NSViewRepresentable {
	typealias NSViewType = SCNView

	@EnvironmentObject var document: QRCode_3DDocument

	func makeNSView(context: Context) -> SCNView {
		let v = SCNView()
		context.coordinator.document = document.qrcode
		context.coordinator.view = v
		return v
	}

	func makeCoordinator() -> QRCodePreviewView.Coordinator {
		Coordinator()
	}

	func updateNSView(_ nsView: SCNView, context: Context) {
		context.coordinator.update()
	}
}
#else
struct QRCodePreviewView: UIViewRepresentable {
	typealias NSViewType = SCNView

	@EnvironmentObject var document: QRCode_3DDocument

	func makeUIView(context: Context) -> SCNView {
		let v = SCNView()
		context.coordinator.document = document.qrcode
		context.coordinator.view = v
		return v
	}

	func makeCoordinator() -> QRCodePreviewView.Coordinator {
		Coordinator()
	}

	func updateUIView(_ uiView: SCNView, context: Context) {
		context.coordinator.update()
	}
}
#endif

#if os(macOS)
func osPath(cgPath: CGPath) -> NSBezierPath {
	return NSBezierPath(cgPath: cgPath)
}
#else
func osPath(cgPath: CGPath) -> UIBezierPath {
	return UIBezierPath(cgPath: cgPath)
}
#endif

extension QRCodePreviewView {
	class Coordinator {
		init() { }

		let debounce = DSFDebounce(seconds: 0.01)

		var document: QRCode.Document?
		var view: SCNView! {
			didSet {
				self.configure()
			}
		}

		private var qrOnPupilShape: SCNShape?
		private var qrEyeShape: SCNShape?
		private var qrPupilShape: SCNShape?
		private var qrBackgroundPlane: SCNPlane?

		func update() {
			debounce.debounce { [weak self] in
				self?._update()
			}
		}

		func _update() {
			guard let qrcode = document else { return }
			do {
				// background
				let bgi = qrcode.design.style.background?.makeImage(dimension: 1000, isFlipped: true)
				qrBackgroundPlane?.materials.first?.diffuse.contents = bgi ?? CGColor(gray: 0, alpha: 0)
				qrBackgroundPlane?.cornerRadius = qrcode.design.style.backgroundFractionalCornerRadius * 1000
			}
			do {
				// On pixels
				let path = qrcode.path(CGSize(width: 1000, height: 1000), components: [.onPixels])
				let mx = CGMutablePath()
				mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
				qrOnPupilShape?.path = osPath(cgPath: mx)
				qrOnPupilShape?.materials.first?.diffuse.contents = qrcode.design.style.onPixels.makeImage(dimension: 1000, isFlipped: true)
			}
			do {
				// Eye
				let path = qrcode.path(CGSize(width: 1000, height: 1000), components: [.eyeOuter])
				let mx = CGMutablePath()
				mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
				qrEyeShape?.path = osPath(cgPath: mx)
				qrEyeShape?.materials.first?.diffuse.contents = qrcode.design.style.actualEyeStyle.makeImage(dimension: 1000, isFlipped: true)
			}
			do {
				// Pupil
				let path = qrcode.path(CGSize(width: 1000, height: 1000), components: [.eyePupil])
				let mx = CGMutablePath()
				mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
				qrPupilShape?.path = osPath(cgPath: mx)
				qrPupilShape?.materials.first?.diffuse.contents = qrcode.design.style.actualPupilStyle.makeImage(dimension: 1000, isFlipped: true)
			}
		}

		func configure() {

			// Scene

			let scene = SCNScene()
			scene.background.contents = CGColor(gray: 0, alpha: 1)
			view.scene = scene
			view.allowsCameraControl = true
			view.translatesAutoresizingMaskIntoConstraints = false

			// Camera

			let cameraNode = SCNNode()
			let camera = SCNCamera()
			camera.usesOrthographicProjection = false
			camera.zFar = 10000
			cameraNode.camera = camera
			cameraNode.position = SCNVector3(x: 0, y: 0, z: 1300)
			scene.rootNode.addChildNode(cameraNode)

			// QRCode shape

			let qrCode = document!

			do {
				let path = qrCode.path(CGSize(width: 1000, height: 1000), components: [.onPixels])
				let mx = CGMutablePath()
				mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
				let p = osPath(cgPath: mx)
				let shape = SCNShape(path: p, extrusionDepth: 20)
				self.qrOnPupilShape = shape

				let n = SCNNode(geometry: shape)
				n.position = SCNVector3(x: -500, y: -500, z: 0)

				scene.rootNode.addChildNode(n)
			}

			do {
				let path = qrCode.path(CGSize(width: 1000, height: 1000), components: [.eyeOuter])
				let mx = CGMutablePath()
				mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
				let p = osPath(cgPath: mx)
				let shape = SCNShape(path: p, extrusionDepth: 20)
				self.qrEyeShape = shape

				let n = SCNNode(geometry: shape)
				n.position = SCNVector3(x: -500, y: -500, z: 0)

				scene.rootNode.addChildNode(n)
			}

			do {
				let path = qrCode.path(CGSize(width: 1000, height: 1000), components: [.eyePupil])
				let mx = CGMutablePath()
				mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
				let p = osPath(cgPath: mx)
				let shape = SCNShape(path: p, extrusionDepth: 20)
				self.qrPupilShape = shape

				let n = SCNNode(geometry: shape)
				n.position = SCNVector3(x: -500, y: -500, z: 0)

				scene.rootNode.addChildNode(n)
			}

			do {
				let plane = SCNPlane(width: 1000, height: 1000)
				self.qrBackgroundPlane = plane
				plane.cornerRadius = 0
				let planeNode = SCNNode(geometry: plane)
				planeNode.position = .init(x: 0, y: 0, z: -9.5)

				let material = SCNMaterial()
				material.isDoubleSided = true
				material.diffuse.contents = CGColor(srgbRed: 0.141, green: 0.035, blue: 0.321, alpha: 1)
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
				//light.color = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
				let lightNode = SCNNode()
				lightNode.light = light
				lightNode.position = SCNVector3(x: -500, y: -500, z: 100)
				scene.rootNode.addChildNode(lightNode)
			}

			do {
				let light = SCNLight()
				light.type = .omni
				light.intensity = 5000
				//light.color = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
				let lightNode = SCNNode()
				lightNode.light = light
				lightNode.position = SCNVector3(x: 0, y: 0, z: -400)
				scene.rootNode.addChildNode(lightNode)
			}

			_update()
		}

		func refreshCode() {
			_update()
//			let qrCode = document!
//
//			let path = qrCode.path(CGSize(width: 1000, height: 1000))
//			let mx = CGMutablePath()
//			mx.addPath(path, transform: .init(scaleX: 1, y: -1).translatedBy(x: 0, y: -1000))
//			qrCodeShape?.path = osPath(cgPath: mx)
//			qrBackgroundPlane?.cornerRadius = qrCode.design.style.backgroundFractionalCornerRadius * 1000
		}
	}
}

#Preview {
	QRCodePreviewView().environmentObject(QRCode_3DDocument())
}
