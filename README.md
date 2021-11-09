# QRCodeView

A simple macOS/iOS/tvOS QR Code control

## Features

* Size to fit available provided space
* Configurable foreground/background colors

## QRCodeView

The NSView/UIView implementation.

| Parameter     | Type                         | Description                                            |
|---------------|------------------------------|--------------------------------------------------------|
| `data`        | `Data`                       | The QR Code content                                    |
| `correction`  | `QRCodeView.ErrorCorrection` | The level of error collection when generating the code |
| `foreColor`   | `CGColor`                    | The QR code color                                      |
| `backColor`   | `CGColor`                    | The background color for the control                   |

## QRCodeViewUI

The SwiftUI implementation

| Parameter         | Type                         | Description                                            |
|-------------------|------------------------------|--------------------------------------------------------|
| `data`            | `Data`                       | The QR Code content                                    |
| `correction`      | `QRCodeView.ErrorCorrection` | The level of error collection when generating the code |
| `foregroundColor` | `Color`                      | The QR code color                                      |
| `backgroundColor` | `Color`                      | The background color for the control                   |


```swift
struct ContentView: View {

   @State var content: String = "This is a test of the QR code control"
   @State var correction: QRCodeView.ErrorCorrection = .low
   @State var foregroundColor = Color.primary
   @State var backgroundColor = Color.clear

   var body: some View {
      HStack {
         VStack {
            HStack {
               Text("Content")
               TextField("Text", text: $content)
            }
            Picker(selection: $correction, label: Text("Error correction:")) {
               Text("Low (L)").tag(QRCodeView.ErrorCorrection.low)
               Text("Medium (M)").tag(QRCodeView.ErrorCorrection.medium)
               Text("High (Q)").tag(QRCodeView.ErrorCorrection.high)
               Text("Max (H)").tag(QRCodeView.ErrorCorrection.highest)
            }.pickerStyle(RadioGroupPickerStyle())

            ColorPicker("Foreground", selection: $foregroundColor)
            ColorPicker("Background", selection: $backgroundColor)

            Spacer()
         }
         .frame(alignment: .top)
         .padding()
         
         QRCodeViewUI(
            content,
            errorCorrection: correction,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
         )
         .frame(alignment: .center)
         .padding()
      }
   }
}

```
