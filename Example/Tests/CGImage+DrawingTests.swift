import XCTest
import Nimble
import SwiftHelpers

final class CGImage_DrawingTests: XCTestCase {

	func drawTestImageInContext(context: CGContext, size: CGSize) {
		// blue background
		let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
		CGContextSetFillColorWithColor(context, backgroundColor)
		CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))

		// red oval
		let ovalPath = CGPathCreateWithEllipseInRect(CGRectMake(0, 50, 50, 50), nil)
		CGContextAddPath(context, ovalPath)
		let color = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1, 0, 0, 1])
		CGContextSetFillColorWithColor(context, color)
		CGContextFillPath(context)
	}

	func testImageGeneration() {
		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: false) { (context, size) in
			drawTestImageInContext(context, size: size)
		}
		expect(image).to(matchReferenceImageNamed("Red50x50OvalInTheTopLeftOfABlue100x100Square"))
	}

	func testFlippedImageGeneration() {
		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
			drawTestImageInContext(context, size: size)
		}
		expect(image).to(matchReferenceImageNamed("Red50x50OvalInTheBottomLeftOfABlue100x100Square"))
	}

}
