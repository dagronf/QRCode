## Resulting QR Code image

<a href="linear-background.png">
   <img src="linear-background.png" width="300" />
</a>

## Code

```swift
let doc = QRCode.Document(utf8String: "https://developer.apple.com/swift/")

doc.design.additionalQuietZonePixels = 1
doc.design.style.backgroundFractionalCornerRadius = 3

let gradient = try DSFGradient.build([
   (0.30, CGColor(srgbRed: 0.005, green: 0.101, blue: 0.395, alpha: 1)),
   (0.55, CGColor(srgbRed: 0, green: 0.021, blue: 0.137, alpha: 1)),
   (0.65, CGColor(srgbRed: 0, green: 0.978, blue: 0.354, alpha: 1)),
   (0.66, CGColor(srgbRed: 1, green: 0.248, blue:0, alpha: 1)),
   (1.00, CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)),
])

let linear = QRCode.FillStyle.LinearGradient(
   gradient,
   startPoint: CGPoint(x: 0.2, y: 0),
   endPoint: CGPoint(x: 1, y: 1)
)

doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.05, cornerRadiusFraction: 1)

doc.design.style.offPixels = QRCode.FillStyle.Solid(gray: 1, alpha: 0.1)
doc.design.shape.offPixels = QRCode.PixelShape.Vertical(insetFraction: 0.05, cornerRadiusFraction: 1)

let imageData = doc.pngData(dimension: 400)
```
