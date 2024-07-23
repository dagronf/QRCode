## Resulting QR Code image

<a href="blobby-style.svg">
   <img src="blobby-style.svg" width="200" />
</a>

## Code

```swift
let svgData = try QRCode.build
   .text("https://www.apple.com/au/")
   .errorCorrection(.medium)
   .eye.shape(QRCode.EyeShape.CRT())
   .onPixels.shape(QRCode.PixelShape.Blob())
   .onPixels.style(
      QRCode.FillStyle.LinearGradient(
         try DSFGradient(pins: [
            DSFGradient.Pin(CGColor.RGBA(1, 0.589, 0, 1), 0),
            DSFGradient.Pin(CGColor.RGBA(1, 0, 0.3, 1), 1),
         ]),
         startPoint: CGPoint(x: 0, y: 1),
         endPoint: CGPoint(x: 0, y: 0)
      )
   )
   .offPixels.shape(QRCode.PixelShape.Circle(insetFraction: 0.3))
   .offPixels.style(QRCode.FillStyle.Solid(0, 0, 0, alpha: 0.1))
   .generate.svg(dimension: 400)
```
