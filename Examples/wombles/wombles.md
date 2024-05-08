## Resulting QR Code image

<a href="qrcode-off-pixels.png">
   <img src="demo-wombles.jpg" width="200" />
</a>

## Code

```swift
let doc = try QRCode.Document(utf8String: "https://en.wikipedia.org/wiki/The_Wombles")

let pixelFill = QRCode.FillStyle.LinearGradient(
   DSFGradient(pins: [
      DSFGradient.Pin(CGColor(red:0, green:0, blue:1, alpha:1), 0),
      DSFGradient.Pin(CGColor(red:1, green:0, blue:0, alpha:1), 1),
   ])!,
   startPoint: CGPoint(x: 0, y: 0),
   endPoint: CGPoint(x: 0, y: 1)
)
doc.design.style.onPixels = pixelFill
doc.design.shape.onPixels = QRCode.PixelShape.RoundedEndIndent(
   cornerRadiusFraction: 1, 
   hasInnerCorners: true
)

doc.design.shape.eye = QRCode.EyeShape.Shield(
   topLeft: false, 
   topRight: true, 
   bottomLeft: true, 
   bottomRight: false
)

let logo = QRCode.LogoTemplate(image: NSImage(named: "wombles")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
logo.path = CGPath(rect: CGRect(x: 0.70, y: 0.375, width: 0.25, height: 0.25), transform: nil)
doc.logoTemplate = logo

let qrCodeImage = try doc.cgImage(dimension: 400)
```

## Logo template image

<a href="b-image.jpg">
   <img src="wombles.jpeg" width="150"/>
</a>
