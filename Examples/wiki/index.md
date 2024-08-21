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
   .background.cornerRadius(1)
   .onPixels.shape(
      .squircle(
         insetGenerator: QRCode.PixelInset.Punch(),
         insetFraction: 0.6
      )
   )
   .eye.shape(.squircle())
   .logo(logo)
   .generate.image(dimension: 600, representation: .png())
```

## Logo Image

<img src="../../Tests/QRCodeTests/Resources/wiki-logo.png" width="150"/>

