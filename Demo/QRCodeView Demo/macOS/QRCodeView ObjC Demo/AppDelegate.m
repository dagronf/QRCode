//
//  AppDelegate.m
//  QRCodeView ObjC Demo
//
//  Created by Darren Ford on 9/11/21.
//

#import "AppDelegate.h"

@import CoreGraphics;
@import QRCode;

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[self doTests];
	[self doBasicQRCodeGeneration];
	[self doBasicQRCodeDocumentGeneration2];
	[self doBasicShadowGeneration];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
	return YES;
}

- (void)doTests {
	id engine = [QRCodeEngineExternal new];

	QRCodeDocument* document = [[QRCodeDocument alloc] initWithEngine: engine error: nil];
	[document setUtf8String: @"This message is something really exciting in objective-c"];
	[document setErrorCorrection: QRCodeErrorCorrectionHigh];

	NSImage* backgroundImage = [NSImage imageNamed:@"square-format-01"];
	document.design.style.background = [[QRCodeFillStyleImage alloc] init: [backgroundImage CGImageForProposedRect:nil context:nil hints:nil]];

	// Set the foreground color to a solid red
	document.design.style.onPixels = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(0.2, 0.2, 1, 1)];
	document.design.style.eye = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(0, 1, 0, 1)];

	// Use the leaf style
	document.design.shape.eye = [[QRCodeEyeShapeLeaf alloc] init];

	CGPathRef path = CGPathCreateWithRect(CGRectMake(0.3, 0.4, 0.4, 0.2), nil);
	//id templ = [[QRCodeLogoTemplate alloc] initWithPath:path inset:0 image: nil];
	CGImageRef logoImage = [[NSImage imageNamed:@"pinksquare"] CGImageForProposedRect:nil context:nil hints:nil];
	id templ = [[QRCodeLogoTemplate alloc] initWithImage:logoImage path:path inset:0 masksQRCodePixels:NO];
	[document setLogoTemplate:templ];

	// Generate the image (with a 216dpi resolution)
	CGImageRef image = [document cgImage: CGSizeMake(900, 900) error: nil];
	NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: CGSizeMake(300, 300)];
	NSLog(@"Image -> %@", nsImage);

	{
		QRCode* code = [[QRCode alloc] init];
		[code updateWithText: @"This message"
			  errorCorrection:QRCodeErrorCorrectionHigh
							error:nil];

		// Create a new design
		QRCodeDesign* design = [QRCodeDesign new];

		// Set the foreground color to a solid red
		design.style.onPixels = [[QRCodeFillStyleSolid alloc] init: CGColorCreateGenericRGB(1, 0, 0, 1)];

		// Use the leaf style
		design.shape.eye = [[QRCodeEyeShapeLeaf alloc] init];

		design.shape.onPixels = [[QRCodePixelShapeCircle alloc] initWithInsetGenerator:[[QRCodePixelInsetPunch alloc] init]
																							  insetFraction:0.5];

		CGImageRef image = [code cgImage:CGSizeMake(400, 400)
										  design:design
								  logoTemplate:nil
											error:nil];
		NSLog(@"image: %@", image);
	}

	{
		QRCodeDocument* doc = [QRCodeDocument new];
		doc.engine = [QRCodeEngineExternal new];

		doc.utf8String = @"This is an objective-c qr code";

		doc.design.shape.onPixels = [QRCodePixelShapeRazor new];

		doc.design.shape.pupil = [QRCodePupilShapeKoala new];

		NSError* error = NULL;
		CGImageRef image = [doc cgImageWithDimension:600 error:&error];
		assert(error == nil);
		NSLog(@"image: %@", image);
	}

	{
		QRCodeDocument* doc = [QRCodeDocument new];
		[doc setUtf8String: @"https://github.com/dagronf/QRCode"];

		NSError* error = NULL;
		CGImageRef image = [doc cgImageWithDimension:600 error:&error];
		NSLog(@"image: %@", image);
	}
}

- (void)doBasicQRCodeGeneration {
	NSError* error = NULL;
	QRCode* code = [[QRCode alloc] initWithUtf8String:@"This is the content"
												 errorCorrection:QRCodeErrorCorrectionHigh
															 engine:NULL
															  error:&error];
	CGImageRef cgr = [code cgImageWithDimension:400
													 design:[[QRCodeDesign alloc] init]
											 logoTemplate:NULL
													  error:&error];

	NSLog(@"%@", cgr);
}

- (void)doBasicQRCodeDocumentGeneration2 {
	NSError* error = NULL;
	QRCodeDocument* doc = [[QRCodeDocument alloc] initWithUtf8String:@"This is the content"
																	  errorCorrection:QRCodeErrorCorrectionHigh
																				  engine:NULL
																					error:&error];
	CGImageRef cgr = [doc cgImageWithDimension:400 error:&error];
	NSLog(@"%@", cgr);
}

- (void)doBasicShadowGeneration {
	NSError* error = NULL;
	QRCodeDocument* doc = [[QRCodeDocument alloc] initWithUtf8String:@"This is the content"
																	  errorCorrection:QRCodeErrorCorrectionHigh
																				  engine:NULL
																					error:&error];

	NSColor* color = [NSColor colorWithRed:1 green:0 blue:0 alpha:1];
	struct CGColor* shadowColor = [color CGColor];

	QRCodeShadow* shadow = [[QRCodeShadow alloc] init: QRCodeShadowTypeDropShadow
																  dx: 0.2
																  dy: -0.2
																blur: 3
															  color: shadowColor];

	doc.design.style.shadow = shadow;
	CGImageRef cgr = [doc cgImageWithDimension:400 error:&error];
	NSLog(@"%@", cgr);
}

@end
