# QRCode

A simple and quick macOS/iOS/tvOS QR Code generator for SwiftUI, Swift and Objective-C.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/QRCode" />
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-13+-blue" />
    <img src="https://img.shields.io/badge/tvOS-13+-orange" />
</p>
<p align="center">
    <img src="https://img.shields.io/badge/Swift-blue" />
    <img src="https://img.shields.io/badge/ObjectiveC-green" />
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

<p align="center">
   <a href="./Art/screenshot.png">
      <img src="./Art/screenshot.png" width="500"/>
   </a>
</p>

## Why?

It's nice to have a simple, quick drop-in component for displaying a QR code.

## Features

* Supports Swift and Objective-C
* Drop-in live display support for SwiftUI, NSView (macOS) and UIView (iOS/tvOS)
* Configurable designs
* Configurable fill styles for image generation

## QRCode

The QRCode class is the core generator class. It is not tied to any presentation medium.

You can use this class to generate a QR Code and present the result as a `CGPath` or a `CGImage`. And if you're using
Swift you can additionally retrieve the raw qr code data as a 2D array of Bool.

<details>
<summary>Example</summary>
 
```swift
let c = QRCode()
c.update(text: "This is my QR code", errorCorrection: .max)

// Generate a path containing the QR code
let path = c.path(CGSize(width: 400, height: 400))

// Generate an image using the default styling (square, black foreground, white background)
let image = c.image(CGSize(width: 400, height: 400))
```

</details>

### Set/Update the QR content

```swift
@objc public func update(_ data: Data, errorCorrection: ErrorCorrection)
@objc public func update(text: String, errorCorrection: ErrorCorrection)
@objc public func update(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection)
```

Update the qrcode with the specified data and error correction.

### Generate a path

```swift
@objc func path(_ size: CGSize, components: Components = .all, shape: QRCode.Shape = QRCode.Shape()) -> CGPath
```

Produces a CGPath representation of the QRCode

* The size in pixels of the generated path
* The components of the qr code to include in the path (defaults to the standard QR components)
   * The eye 'outer' ring
   * The eye pupil
   * The pixels that are 'on' within the QR Code
   * The pixels that are 'off' within the QR Code
* The shape of the qr components

The components allow the caller to generate individual paths for the QR code components which can then be individually 
styled and recombined later on. 

For example, the SwiftUI implementation is a Shape object, and you can use a ZStack to overlay each 
component using different a different fill style (for example).

```swift
   let qrContent = QRCodeUI(myData)
   ...
   ZStack {
      qrContent
         .components(.eyeOuter)
         .fill(.green)
      qrContent
         .components(.eyePupil)
         .fill(.teal)
      qrContent
         .components(.onPixels)
         .fill(.black)
   }
```

### Generate an image

```swift
@objc func image(_ size: CGSize, scale: CGFloat = 1, style: QRCode.Style = QRCode.Style()) -> CGImage?
```

A convenience method for generating an image from the QR Code.

## Styling

`QRCode` supports a number of ways of stying your code

### Eye shape

You can provide an `EyeShape` object to style just the eyes of the generated qr code. There are built-in generators for
square, circle, rounded rectangle, and more.

### Data shape

The data shape represents how the 'pixels' within the QR code are displayed.  By default, this is a simple square, 
however you can supply a `DataShape` object to custom-draw the data.  There are built-in generators for simple square, 
circle, rounded rectangle and some more complex ones (horizontal bars for example).

## Message Formatters

There are a number of QRCode data formats that are somewhat common with QR code readers, such as QR codes 
containing phone numbers or contact details.

There are a number of built-in formatters for some common QR Code types. These can be found in the `messages` subfolder.

* URLs (Link)
* Generate an email (Mail)
* A phone number (Phone)
* Contact Details (Contact)
* A UTF-8 formatted string (Text)

## Presentation

### NSView/UIView

`QRCodeView` is an NSView (macOS)/UIView (iOS/tvOS) implementation for displaying the content of a `QRCode` object.

### SwiftUI

`QRCodeUI` is the SwiftUI implementation which presents as a Shape. So anything you can do with a (eg.) SwiftUI Rectangle shape you 
can do with a QRCode.

For example, you can use `.fill` to set the color content (eg. a linear gradient, solid color etc), add a drop shadow,
add a transform etc...


| Parameter         | Type                         | Description                                            |
|-------------------|------------------------------|--------------------------------------------------------|
| `data`            | `Data`                       | The QR Code content                                    |
| `errorCorrection` | `QRCodeView.ErrorCorrection` | The level of error collection when generating the code |

### Modifiers

```swift
func errorCorrection(_ errorCorrection: QRCode.ErrorCorrection) -> QRCodeUI {
```
Set the error correction level

```swift
func components(_ components: QRCode.Components) -> QRCodeUI
```

Set which components of the QR code to be added to the path

```swift
func contentShape(_ shape: QRCode.Shape) -> QRCodeUI
func eyeShape(_ eyeShape: QRCodeEyeShape) -> QRCodeUI
func dataShape(_ dataShape: QRCodeDataShape) -> QRCodeUI
```

Set the shape for the eye/data or both.

<details>
<summary>Example</summary> 

```swift
struct ContentView: View {

   @State var content: String = "This is a test of the QR code control"
   @State var correction: QRCodeView.ErrorCorrection = .low

   var body: some View {
      Text("Here is my QR code")
      QRCode(
         text: content,
         errorCorrection: correction
      )
      .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
      .shadow(color: .black, radius: 1, x: 1, y: 1)
      .frame(width: 250, height: 250, alignment: .center)
   }
}
```
</details>

## Objective-C

The `QRCode` library fully supports Objective-C.

<details>
<summary>Example</summary> 

```objc
QRCode* code = [[QRCode alloc] init];
[code updateWithText: @"This message"
     errorCorrection: QRCodeErrorCorrectionMax];

QRCodeStyle* style = [[QRCodeStyle alloc] init];

// Set the foreground color to a solid red
style.foregroundStyle = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(1, 0, 0, 1)];

// Use the leaf style
style.shape.eyeShape = [[QRCodeEyeStyleLeaf alloc] init];

// Generate the image
CGImageRef image = [code image: CGSizeMake(400, 400) scale: 1.0 style: style];
NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: CGSizeZero];
```
</details>

## License

MIT. Use it for anything you want, just attribute my work. Let me know if you do use it somewhere, I'd love to hear about it!

```
MIT License

Copyright (c) 2021 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
