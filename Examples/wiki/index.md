## Resulting QR Code image

<a href="wiki.png">
   <img src="wiki.png" width="200" />
</a>

## Code

```swift
let image = try resourceImage(for: "wiki-logo", extension: "png")

// Centered circular logo
let logo = QRCode.LogoTemplate(
   image: image,
   path: CGPath(
      ellipseIn: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30),
      transform: nil
   ),
   inset: 16
)

let pngData = try QRCode.build
   .text("https://en.wikipedia.org/wiki/QR_code")
   .errorCorrection(.high)
   .backgroundColor(.RGBA(0.1849, 0.0750, 0.2520))
   .onPixels.shape(
      .circle(
         insetGenerator: QRCode.PixelInset.Punch(),
         insetFraction: 0.6
      )
   )
   .onPixels.style(.RGBA(0.8523, 0.7114, 0.3508))
   .eye.shape(.circle())
   .logo(logo)
   .generate.image(dimension: 600, representation: .png())
```

## Logo Image

<img src="../../Tests/QRCodeTests/Resources/wiki-logo.png" width="150"/>

