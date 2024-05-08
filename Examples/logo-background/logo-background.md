## Resulting QR Code image

<a href="qrcode-off-pixels.png">
   <img src="demo-simple-image-background.jpg" width="150" />
</a>

## Code

```swift
let doc = try QRCode.Document("This is an image background")

doc.design.style.background = QRCode.FillStyle.Image(NSImage(named: "background-fill-image"))
doc.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1, alpha: 0.5)

// Generate the image
let qrCodeImage = doc.cgImage(dimension: 400)
```

## Background Image

<a href="b-image.jpg">
   <img src="../../Tests/QRCodeTests/Resources/photo-logo.jpg" width="150"/>
</a>
