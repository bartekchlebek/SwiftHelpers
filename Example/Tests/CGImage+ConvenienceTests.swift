import XCTest
import Nimble
import SwiftHelpers

private final class CGImage_ConvenienceTests: XCTestCase {

	private let imageForTests = {
		return try! CGImage.imageWithSize(CGSizeMake(100, 50)) { (context, size) in
			// blue background
			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
			CGContextSetFillColorWithColor(context, backgroundColor)
			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))

			// red oval
			let ovalPath = CGPathCreateWithEllipseInRect(CGRectMake(0, 40, 50, 20), nil)
			CGContextAddPath(context, ovalPath)
			let color = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1, 0, 0, 1])
			CGContextSetFillColorWithColor(context, color)
			CGContextFillPath(context)
		}
	}()

	func testConvenienceProperties() {
		let image = self.imageForTests
		expect(image.width) == CGImageGetWidth(image)
		expect(image.height) == CGImageGetHeight(image)
		expect(image.size) == CGSizeMake(CGFloat(image.width), CGFloat(image.height))
		expect(image.bytesPerRow) == CGImageGetBytesPerRow(image)
		expect(image.bitsPerComponent) == CGImageGetBitsPerComponent(image)
		expect(image.bitsPerPixel) == CGImageGetBitsPerPixel(image)
		//TODO:Figure out how to compare CGColorSpace
//		expect(image.colorSpace) == CGImageGetColorSpace(image)
	}
	
}
