## Resulting QR Code image

<a href="qrcode-with-logo.pdf">
   <img src="qrcode-with-logo.png" width="150" />
</a>

## Code

```swift
let doc = QRCode.Document(utf8String: "QR Code with overlaid logo", errorCorrection: .high)
doc.design.backgroundColor(CGColor(srgbRed: 0.149, green: 0.137, blue: 0.208, alpha: 1.000))
doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
doc.design.style.onPixels = QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000)

doc.design.style.eye   = QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000)
doc.design.style.pupil = QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000)

doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

let image = NSImage(named: "square-logo")!

// Centered square logo
doc.logoTemplate = QRCode.LogoTemplate(
   image: image.cgImage!,
   path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
   inset: 2
)

let logoQRCode = doc.platformImage(dimension: 300, dpi: 144)
let pdfData = doc.pdfData(dimension: 300)!
```

## Logo Image

<img src="../../Demo/QRCodeView Demo/QRCodeView Documentation Images/Assets.xcassets/square-logo.imageset/square-logo.png" width="150"/>

