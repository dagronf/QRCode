## Resulting QR Code image

<a href="lcd.svg">
   <img src="lcd.svg" width="300" />
</a>

## Code

```swift
let shadow = QRCode.Shadow(
   .dropShadow,
   dx: 0.2,
   dy: -0.2,
   blur: 2,
   color: CGColor.sRGBA(0, 0, 0, 0.25)
)

let svgData = try QRCode.build
   .text("https://www.deltakit.net/product/16x2-lcd-module-green/")
   .errorCorrection(.quantize)
   .backgroundColor(hexString: "#77CE07")
   .background.cornerRadius(2)
   .shadow(shadow)
   .eye.shape(QRCode.EyeShape.Squircle())

   .onPixels.foregroundColor(hexString: "#074302")
   .onPixels.shape(QRCode.PixelShape.Grid2x2())

   .offPixels.foregroundColor(CGColor(gray: 0, alpha: 0.15))
   .offPixels.shape(QRCode.PixelShape.Grid2x2())

   .generate.svg(dimension: 800)
```
