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

	QRCode* code = [[QRCode alloc] init];
	[code updateWithText: @"This message"
		  errorCorrection: QRCodeErrorCorrectionHigh];

	QRCodeDesign* design = [QRCodeDesign create];

	// Set the foreground color to a solid red
	
	design.style.data = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(1, 0, 0, 1)];
	design.style.eye = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(0, 1, 0, 1)];

	// Use the leaf style
	design.shape.eye = [[QRCodeEyeShapeLeaf alloc] init];

	// Generate the image
	CGImageRef image = [code cgImage: CGSizeMake(400, 400)
										scale: 1.0
									  design: design];

	NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: CGSizeZero];
	NSLog(@"Image -> %@", nsImage);
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
