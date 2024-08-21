## Resulting QR Code image

<a href="qrcode-with-logo.pdf">
   <img src="qrcode-with-logo.png" width="150" />
</a>

## Code

### Swift code

```swift
let doc = try QRCode.Document(utf8String: "QR Code with overlaid logo", errorCorrection: .high)
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

let logoQRCode = try doc.platformImage(dimension: 300, dpi: 144)
let pdfData = try doc.pdfData(dimension: 300)!
```

### Builder

```swift
let doc = try QRCode.build
   .text("QR Code with overlaid logo")
   .errorCorrection(.high)
   .backgroundColor(CGColor.sRGBA(0.149, 0.137, 0.208))
   .onPixels.shape(QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8))
   .onPixels.style(QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000))
   .eye.style(QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000))
   .pupil.style(QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000))
   .logo(
      QRCode.LogoTemplate(
         image: try resourceImage(for: "square-logo", extension: "png"),
         path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
         inset: 2
      )
   )
   .document
```

## Logo Image

<img src="../../Tests/QRCodeTests/Resources/square-logo.png" width="150"/>
