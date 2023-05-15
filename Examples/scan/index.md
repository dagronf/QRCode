## Resulting QR Code image

<a href="qrcode-with-basic-logo.svg">
   <img src="qrcode-with-basic-logo.svg" width="150" />
</a>

## Code

```swift
let doc = QRCode.Document(utf8String: "https://www.qrcode.com/en/history/", errorCorrection: .high)

doc.design.shape.eye = QRCode.EyeShape.Squircle()
doc.design.style.eye = QRCode.FillStyle.Solid(108.0 / 255.0, 76.0 / 255.0, 191.0 / 255.0)
doc.design.style.pupil = QRCode.FillStyle.Solid(168.0 / 255.0, 33.0 / 255.0, 107.0 / 255.0)

doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)

let c = QRCode.FillStyle.RadialGradient(
   DSFGradient(pins: [
      DSFGradient.Pin(CGColor(red: 1, green: 1, blue: 0.75, alpha: 1), 1),
      DSFGradient.Pin(CGColor(red: 1, green: 1, blue: 0.95, alpha: 1), 0),
   ])!,
   centerPoint: CGPoint(x: 0.5, y: 0.5)
)

doc.design.style.background = c

// Create a logo 'template'
doc.logoTemplate = QRCode.LogoTemplate(
	image: NSImage(named: "scan-logo")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
	path: CGPath(rect: CGRect(x: 0.49, y: 0.4, width: 0.45, height: 0.22), transform: nil),
	inset: 4
)
```

## Logo Image

<img src="../../Demo/QRCodeView Demo/QRCodeView Documentation Images/Assets.xcassets/apple-logo.imageset/logotymp.png" width="150"/>

