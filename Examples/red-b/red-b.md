## Resulting QR Code image

<a href="qrcode-off-pixels.png">
     <img src="qrcode-off-pixels.jpg" width="150"/>
</a>

## Code

```swift
let doc = QRCode.Document(
   utf8String: "http://www.bom.gov.au/products/IDR022.loop.shtml", 
   errorCorrection: .high
)

// Set the background image
let backgroundImage = /* load "b-image.jpg" */
doc.design.style.background = QRCode.FillStyle.Image(backgroundImage)

// The red component color
let red_color = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)

// Use Squircle for the eye
doc.design.shape.eye = QRCode.EyeShape.Squircle()
// We need to set the color of the eye background, or else the background image shows 
// through the eye (which is bad for recognition)
doc.design.style.eyeBackground = red_color

// Make the 'on' pixels white
doc.design.style.onPixels = QRCode.FillStyle.Solid(1, 1, 1)
doc.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.5)

// Make the 'off' pixels red
doc.design.style.offPixels = QRCode.FillStyle.Solid(red_color)
doc.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.5)

// Generate the image
let qrCodeImage = doc.cgImage(dimension: 600)
```

## Background Image

<a href="b-image.jpg">
     <img src="b-image.jpg" width="150"/>
</a>
