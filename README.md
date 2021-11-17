# QRCodeView

A simple macOS/iOS/tvOS QR Code generator view for Swift, Objective-C and SwiftUI.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/QRCodeView" />
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-13+-blue" />
    <img src="https://img.shields.io/badge/tvOS-13+-orange" />
</p>
<p align="center">
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

![Screenshot](./Art/screenshot.png)

## Why?

It's nice to have a simple drop-in component for displaying a QR code.

## Features

* Supports Swift and Objective-C
* Supports NSView (macOS), UIView (iOS/tvOS) and SwiftUI
* Size to fit available provided space
* Configurable foreground/background colors
* Configurable designs

## QRCode

The QRCode class is the core generator class.  It is not tied to any presentation medium.

### Update the QR content

```swift
@objc public func update(_ data: Data, errorCorrection: ErrorCorrection)
@objc public func update(text: String, errorCorrection: ErrorCorrection)
@objc public func update(message: QRCodeMessageFormatter, errorCorrection: ErrorCorrection)
```

Update the qrcode with the specified data and error correction.

### Generate a path

```swift
@objc func path(_ size: CGSize, components: Components = .all, shape: QRCode.Shape = QRCode.Shape())
```

Produces a CGPath representation of the QRCode

* The size in pixels of the generated path
* The components of the qr code to include in the path (defaults to the standard QR components)
   * The eye 'outer' ring
   * The eye pupil
   * The pixels that are 'on' within the QR Code
   * The pixels that are 'off' within the QR Code
* The shape of the qr components

The components allow the caller to generate individual paths for the QR code components which can then be combined
together later on.  For example, the SwiftUI implementation is a Shape object, and you can use a ZStack to overlay each 
path using different fill styles.

```swift
   let qrContent = QRCodeUI(myData)
   ...
   qrContent
      .components(.eye)
      .fill(.green)
   qrContent
      .components(.eyePupil)
      .fill(.teal)
   qrContent
      .components(.content)
      .fill(.black)
```

### Generate an image

```swift
@objc func image(_ size: CGSize, scale: CGFloat = 1, style: QRCode.Style = QRCode.Style()) -> CGImage?
```

A convenience method for generating an image from the QR Code.



## QRCodeView

A NSView/UIView implementation.


## SwiftUI

The SwiftUI implementation is a basic Shape type. So anything you can do with a (eg.) Swift Rectangle shape you 
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

```
func components(_ components: QRCode.Components) -> QRCodeUI
```

Set the components of the 


#### `pixelStyle`

#### `components`




### Example

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
