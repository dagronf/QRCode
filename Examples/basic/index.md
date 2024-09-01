# A basic QR Code

## Resulting QR Code image

<a href="basic.png">
   <img src="basic.png" width="300" />
</a>

## Code

### Swift

```swift
let cgImage = try QRCode.build
   .text("https://github.com/dagronf/QRCode")
   .generate.image(dimension: 600)
```

### Objective-C

```objective-c
QRCodeDocument* doc = [QRCodeDocument new];
[doc setUtf8String: @"https://github.com/dagronf/QRCode"];

NSError* error = NULL;
CGImageRef image = [doc cgImageWithDimension:600 error:&error];
```
