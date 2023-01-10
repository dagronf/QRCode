//
//  ViewController.m
//  QRCodeView ObjC Demo
//
//  Created by Darren Ford on 9/11/21.
//

#import "ViewController.h"

@import CoreGraphics;
@import QRCode;

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.

	QRCodeDocument* document = [[QRCodeDocument alloc] init];
	[document setUtf8String: @"This message is something really exciting in objective-c"];
	[document setErrorCorrection: QRCodeErrorCorrectionHigh];

	// Set the foreground color to a solid red
	document.design.style.onPixels = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(1, 0, 0, 1)];
	document.design.style.eye = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(0, 1, 0, 1)];

	// Use the leaf style
	document.design.shape.eye = [[QRCodeEyeShapeLeaf alloc] init];

	CGPathRef path = CGPathCreateWithRect(CGRectMake(0.3, 0.4, 0.4, 0.2), nil);
	id templ = [[QRCodeLogoTemplate alloc] initWithPath:path inset:0 image: nil];
	[document setLogoTemplate:templ];

	// Generate the image (with a 216dpi resolution)
	CGImageRef image = [document cgImage: CGSizeMake(900, 900)];
	NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: CGSizeMake(300, 300)];
	NSLog(@"Image -> %@", nsImage);
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
