## Resulting QR Code image

<a href="svgExportPixelBackgroundColors.svg">
   <img src="svgExportPixelBackgroundColors.svg" width="200" />
</a>

## Code

```swift
let d = try QRCode.Document(engine: QRCodeEngine_External())
d.utf8String = "https://www.swift.org"

d.design.backgroundColor(CGColor(srgbRed: 0, green: 0.6, blue: 0, alpha: 1))

d.design.style.eye = QRCode.FillStyle.Solid(gray: 1)
d.design.style.eyeBackground = CGColor(gray: 0, alpha: 0.2)

d.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
d.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
d.design.style.onPixelsBackground = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.2)

d.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
d.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0)
d.design.style.offPixelsBackground = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)

let svg = try d.svg(dimension: 600)
```
