## Resulting QR Code image

<a href="basic-inner-shadow.svg">
   <img src="basic-inner-shadow.svg" width="300" />
</a>

## Code

```swift
let svgData = try QRCode.build
   .text("https://github.com/dagronf/QRCode")
   .background.color(.black)
   .background.cornerRadius(2)
   .onPixels.foregroundColor(CGColor.sRGBA(0.119, 0.89, 1))
   .onPixels.shape(.horizontal(insetFraction: 0.05))
   .eye.shape(.barsHorizontal())
   .shadow(.innerShadow, dx: 0.15, dy: -0.15, blur: 8, color: CGColor.gray(0))
   .generate.svg(dimension: 600)
ry outputFolder.write(svgData, to: "basic-inner-shadow.svg")
```
