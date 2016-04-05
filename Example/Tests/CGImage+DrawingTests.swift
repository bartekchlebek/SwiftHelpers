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

	func testSwiftLogo() {
		let image = try! CGImage.imageWithSize(CGSizeMake(256, 256)) { (context, size) in

			let shorterSide = min(size.width, size.height)
			let badgeSize = CGSizeMake(shorterSide, shorterSide)
			CGContextTranslateCTM(context, (size.width - badgeSize.width) * 0.5, (size.height - badgeSize.height) * 0.5)

			let badgePath = CGPathCreateMutable()
			let badgeRect = CGRectMake(0, 0, badgeSize.width, badgeSize.height)
			let cornerRadius = badgeSize.width * 0.25
			CGPathAddRoundedRect(badgePath, nil, badgeRect, cornerRadius, cornerRadius)
			CGContextAddPath(context, badgePath)

			let badgeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [239 / 255, 81 / 255, 56 / 255, 1])
			CGContextSetFillColorWithColor(context, badgeColor)
			CGContextFillPath(context)

			let swiftLogoAspectRatio: CGFloat = 36.5 / 32.6
			let swiftLogoWidth = badgeSize.width * 0.75
			let swiftLogoHeight = swiftLogoWidth / swiftLogoAspectRatio
			let swiftLogoRect = CGRectMake((badgeSize.width - swiftLogoWidth) * 0.5,
			                               (badgeSize.height - swiftLogoHeight) * 0.5,
			                               swiftLogoWidth,
			                               swiftLogoHeight)

			CGContextTranslateCTM(context, swiftLogoRect.origin.x, swiftLogoRect.origin.y)

			let horizontalScale = swiftLogoRect.width / 36.5
			let verticalScale = swiftLogoRect.height / 32.6
			CGContextScaleCTM(context, horizontalScale, verticalScale)

			let path = CGPathCreateMutable()

			CGPathMoveToPoint(path, nil, 32.5, 22.3)
			CGPathAddCurveToPoint(path, nil, 32.5, 22.3, 32.5, 22.3, 32.5, 22.3)
			CGPathAddCurveToPoint(path, nil, 32.5, 22.1, 32.6, 21.9, 32.6, 21.8)
			CGPathAddCurveToPoint(path, nil, 34.6, 14, 29.8, 4.8, 21.7, 0)
			CGPathAddCurveToPoint(path, nil, 25.2, 4.8, 26.8, 10.6, 25.4, 15.7)
			CGPathAddCurveToPoint(path, nil, 25.3, 16.2, 25.1, 16.6, 25, 17)
			CGPathAddCurveToPoint(path, nil, 24.8, 16.9, 24.6, 16.8, 24.3, 16.6)
			CGPathAddCurveToPoint(path, nil, 24.3, 16.6, 16.3, 11.5, 7.6, 2.9)
			CGPathAddCurveToPoint(path, nil, 7.4, 2.7, 12.2, 9.9, 17.8, 15.7)
			CGPathAddCurveToPoint(path, nil, 15.2, 14.2, 7.9, 9, 3.4, 4.8)
			CGPathAddCurveToPoint(path, nil, 4, 5.7, 4.6, 6.6, 5.4, 7.5)
			CGPathAddCurveToPoint(path, nil, 9.2, 12.4, 14.2, 18.4, 20.2, 23)
			CGPathAddCurveToPoint(path, nil, 16, 25.6, 10, 25.8, 4.1, 23)
			CGPathAddCurveToPoint(path, nil, 2.6, 22.3, 1.3, 21.5, 0, 20.5)
			CGPathAddCurveToPoint(path, nil, 2.5, 24.5, 6.4, 28, 11.1, 30)
			CGPathAddCurveToPoint(path, nil, 16.7, 32.4, 22.3, 32.2, 26.4, 30)
			CGPathAddLineToPoint(path, nil, 26.4, 30)
			CGPathAddCurveToPoint(path, nil, 28.1, 28.9, 32.7, 27.2, 35, 31.7)
			CGPathAddCurveToPoint(path, nil, 35.4, 32.6, 36.5, 27.3, 32.5, 22.3)
			CGPathCloseSubpath(path)

			CGContextAddPath(context, path)
			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1, 1, 1, 1])
			CGContextSetFillColorWithColor(context, backgroundColor)
			CGContextFillPath(context)
		}

		expect(image).to(matchReferenceImageNamed("SwiftLogo"))
	}

}
