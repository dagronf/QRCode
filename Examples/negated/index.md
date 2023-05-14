## Resulting QR Code image

<a href="design-negated-quiet-space.png">
   <img src="design-negated-quiet-space.png" width="300" />
</a>

## Code

```swift
let doc = QRCode.Document(
   utf8String: "QRCode drawing only the 'off' pixels of the qr code with quiet space", 
   errorCorrection: .high
)
doc.design.additionalQuietZonePixels = 6
doc.design.style.backgroundFractionalCornerRadius = 4
doc.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.05)
doc.design.shape.negatedOnPixelsOnly = true

// Black background
doc.design.style.background = QRCode.FillStyle.Solid(gray: 0)
// White foreground
doc.design.foregroundStyle(QRCode.FillStyle.Solid(gray: 1))

let qrCodeImage = doc.cgImage(dimension: 600)
```
