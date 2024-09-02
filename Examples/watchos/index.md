## Resulting QR Code image

<a href="watchos-qrcode.png">
   <img src="watchos-qrcode.png" width="200" />
</a>

## Code

### Builder

```swift
let pngData = try QRCode.build
   .text("QRCode WatchOS Demo")
   .errorCorrection(.medium)
   .backgroundColor(hexString: "000033")
   .quietZonePixelCount(1)
   .background.cornerRadius(4)
   .onPixels.foregroundColor(hexString: "FFFF80")
   .eye.shape(QRCode.EyeShape.RoundedOuter())
   .eye.foregroundColor(hexString: "FEE521")
   .pupil.foregroundColor(hexString: "FFCC4D")
   .generate.image(dimension: 300, representation: .png(scale: 2))
```
