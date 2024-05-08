## Resulting QR Code image

<a href="wwf.svg">
     <img src="wwf.svg" width="200"/>
</a>

## Code

```swift
let doc = try QRCode.Document("https://www.worldwildlife.org")

let backgroundImage = NSImage(named: "wwf")
doc.design.style.background = QRCode.FillStyle.Image(image: backgroundImage)

doc.design.style.eyeBackground = CGColor(gray: 1, alpha: 1)

doc.design.shape.onPixels = QRCode.PixelShape.Star(insetFraction: 0.4)
doc.design.style.onPixels = QRCode.FillStyle.Solid(.black)

doc.design.shape.offPixels = QRCode.PixelShape.Star(insetFraction: 0.4)
doc.design.style.offPixels = QRCode.FillStyle.Solid(.white)

doc.design.shape.eye = QRCode.EyeShape.Leaf()
doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()

// Generate the image
let svg = try doc.svg(dimension: 300)
```

## Background Image

<a href="wwf.jpeg">
     <img src="wwf.jpeg" width="150"/>
</a>
