# QRCode

A simple and quick macOS/iOS/tvOS QR Code generator library for SwiftUI, Swift and Objective-C.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/QRCode" />
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>
<p align="center">
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-13+-blue" />
    <img src="https://img.shields.io/badge/tvOS-13+-orange" />
    <img src="https://img.shields.io/badge/macCatalyst-1.0+-purple" />
</p>
<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.4-blueviolet" />
    <img src="https://img.shields.io/badge/ObjectiveC-2.0-ff69b4" />
    <img src="https://img.shields.io/badge/SwiftUI-2.0+-9cf" />
</p>

<p align="center">
   <a href="./Art/screenshot.png">
      <img src="./Art/screenshot.png" width="500"/>
   </a>
</p>

## Why?

It's nice to have a simple, quick drop-in component for displaying a QR code when you need one :-).

This also contains a command-line application for generating a qrcode from the command line (`qrcodegen`).

## Features

* Supports Swift and Objective-C.
* Generate a QR code without access to a UI.
* Supports all error correction levels.
* Drop-in live display support for SwiftUI, NSView (macOS) and UIView (iOS/tvOS).
* Generate images, scalable PDFs and `CGPath`.
* Configurable designs.
* Configurable fill styles (solid, linear gradient, radial gradient) for image generation.
* Command line tool for generating qr codes from the command line (macOS 10.13+).

## QRCode

The QRCode class is the core generator class. It is not tied to any presentation medium.

You can use this class to generate a QR Code and present the result as a `CGPath` or a `CGImage`. And if you're using
Swift you can retrieve the raw qr code data as a 2D array of `Bool` to use however you need.

<details>
<summary>tl;dr Simple Example</summary>
 
```swift
let qrCode = QRCode()

// Create a qr code containing "Example Text" and set the error correction to maximum ('H') 
qrCode.update(text: "Example text", errorCorrection: .max)

// Generate a CGPath object containing the QR code
let path = qrCode.path(CGSize(width: 400, height: 400))

// Generate an image using the default styling (square, black foreground, white background)
let image = qrCode.image(CGSize(width: 400, height: 400))

// Generate pdf data containing the qr code
let pdfdata = qrCode.pdfData(CGSize(width: 400, height: 400))
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
@objc func path(_ size: CGSize, components: Components = .all, design: QRCode.Design = QRCode.Design()) -> CGPath
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

### Generating a styled image

```swift
@objc func image(_ size: CGSize, scale: CGFloat = 1, design: QRCode.Design = QRCode.Design()) -> CGImage?
```

Generate an image from the QR Code, using an (optional) design object for styling the QR code

```swift
@objc func nsImage(_ size: CGSize, scale: CGFloat = 1, design: QRCode.Design = QRCode.Design()) -> NSImage?
```

*(macOS only)* Generate an NSImage from the QR Code, using an (optional) design object for styling the QR code

```swift
@objc func uiImage(_ size: CGSize, scale: CGFloat = 1, design: QRCode.Design = QRCode.Design()) -> UIImage?
```

*(iOS/tvOS only)* Generate an UIImage from the QR Code, using an (optional) design object for styling the QR code

### Generate a styled, scalable PDF representation of the QR Code

```swift
@objc func pdfData(_ size: CGSize, pdfResolution: CGFloat, design: QRCode.Design = QRCode.Design()) -> Data?
```

Generate a scalable PDF from the QRCode using an (optional) design object for styling the QR code and resolution

### Generate a text representation of the QR code

```swift
@objc func asciiRepresentation() -> String
```

Return an ASCII representation of the QR code using the extended ASCII code set

Only makes sense if presented using a fixed-width font.
	
```swift
@objc func smallAsciiRepresentation() -> String
```

Returns an small ASCII representation of the QR code (about 1/2 the regular size) using the extended ASCII code set

Only makes sense if presented using a fixed-width font.

## Design

`QRCode` supports a number of ways of 'designing' your qr code.  By default, the qr code will be generated in its traditional form - square, black foreground and white background. By tweaking the design settings of the qr code you can make it a touch fancier.

### Fill styles

You can provide a custom fill for any of the individual components (eyes, pupils, data) of the qr code. This library supports the current fill types.

* solid fill
* linear gradient
* radial gradient

### Eye shape

You can provide an `EyeShape` object to style just the eyes of the generated qr code. There are built-in generators for
square, circle, rounded rectangle, and more.

* `square`: Simple square (default)
* `circle`: Simple circle
* `roundedrect`: Simple rounded rect
* `roundedouter`: A square with the outer corner rounded.
* `roundedpointingin`: A rounded rect with the 'inner' corner as a point
* `leaf`: An eye that look like a leaf
* `squircle`: A superellipse (somewhere between a square and a circle)

### Data shape

The data shape represents how the 'pixels' within the QR code are displayed.  By default, this is a simple square, 
however you can supply a `DataShape` object to custom-draw the data.  There are built-in generators for

* `square`: A basic square pixel
* `circle`: A basic circle pixel
* `squircle`: A superellipse (somewhere between a square and a circle)
* `roundedrect`: A basic rounded rectangle pixel with configurable radius
* `horizontal`: The pixels are horizonally joined to make continuous horizontal bars
* `vertical`: The pixels are vertically joined to make continuous vertical bars
* `roundedpath`: A smooth rounded-edge path

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

This library provides drop-in components for presenting a styled QR code.

### NSView/UIView

`QRCodeView` is an `NSView` (macOS)/`UIView` (iOS/tvOS) implementation for displaying the content of a `QRCode` object.

### SwiftUI

`QRCodeUI` is the SwiftUI implementation which presents as a Shape. So anything you can do with any SwiftUI shape object 
(eg. a rectangle) you can now do with a styled QRCode shape outline. 

For example, you can use `.fill` to set the color content (eg. a linear gradient, solid color etc), add a drop shadow,
add a transform etc...

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
style.data = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(1, 0, 0, 1)];

// Use the leaf style
style.shape.eyeShape = [[QRCodeEyeStyleLeaf alloc] init];

// Generate the image
CGImageRef image = [code image: CGSizeMake(400, 400) scale: 1.0 style: style];
NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: CGSizeZero];
```
</details>

## Demo

There are a number of demo apps which you can find in the `Demo` subfolder.  There are simple demo applications for

* SwiftUI (macOS, iOS, macCatalyst)
* iOS (Swift, including macCatalyst)
* macOS (Swift and Objective-C)

## Command line tool

You can build the command line tool by opening a terminal window, `cd` into the QRCode folder and build using

`swift build -c release`

The `qrcodegen` tool can be found in the `.build/release` folder.

```zsh
% .build/release/qrcodegen --help
OVERVIEW: Create a qr code

* If you don't specify either -t or --input-file, the qrcode content will be read from STDIN
* If you don't specify an output file, the generated qr code will be written to a temporary file
  and opened in the default application.

USAGE: qr-code-gen [<options>] <dimension>

ARGUMENTS:
  <dimension>             The QR code dimension. 

OPTIONS:
  --input-file <input-file>
                          The file containing the content for the QR code 
  --output-file <output-file>
                          The output file 
  --output-format <output-format>
                          The output format (png [default],pdf,ascii,smallascii) 
  --output-compression <output-compression>
                          The output format compression factor (if the output format supports it, png,jpg) 
  -t, --text <text>       The text to be stored in the QR code 
  -s, --silence           Silence any output 
  -c, --error-correction <error-correction>
                          The level of error correction. Available levels are "L" (low), "M" (medium), "Q" (high), "H"
                          (max) 
  -e, --eye-shape <eye-shape>
                          The eye shape to use. Available shapes are circle, leaf, roundedouter, roundedpointingin,
                          roundedrect, squircle, square 
  -d, --data-shape <data-shape>
                          The data shape to use. Available shapes are circle, horizontal, roundedpath, roundedrect,
                          square, squircle, vertical 
  -n, --inset <inset>     The spacing around each individual pixel in the data section 
  -r, --data-shape-corner-radius <data-shape-corner-radius>
                          The data shape corner radius fractional value (0.0 -> 1.0) 
  --bg-color <bg-color>   The background color to use (format r,g,b,a - 1.0,0.5,0.5,1.0) 
  --data-color <data-color>
                          The data color to use (format r,g,b,a - 1.0,0.5,0.5,1.0) 
  --eye-color <eye-color> The eye color to use (format r,g,b,a - 1.0,0.5,0.5,1.0) 
  --pupil-color <pupil-color>
                          The pupil color to use (format r,g,b,a - 1.0,0.5,0.5,1.0) 
  -h, --help              Show help information.

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
