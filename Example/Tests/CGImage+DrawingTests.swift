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

//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
//			let scaleH = size.width / 36.5
//			let scaleV = size.height / 32.6
//			CGContextScaleCTM(context, scaleH, scaleV)
//
//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			let origin = CGPointMake(32.5, 22.3)
//			var cp = CGPathGetCurrentPoint(path)
//
//			CGPathMoveToPoint(path, nil, origin.x, origin.y)
//			CGPathAddCurveToPoint(path, nil, origin.x, origin.y, origin.x, origin.y, origin.x, origin.y)
//			CGPathAddCurveToPoint(path, nil, 32.5, 22.1, 32.6, 21.9, 32.6, 21.8)
//			CGPathAddCurveToPoint(path, nil, 34.6, 14, 29.8, 4.8, 21.7, 0)
//			CGPathAddCurveToPoint(path, nil, 25.2, 4.8, 26.8, 10.6, 25.4, 15.7)
//			CGPathAddCurveToPoint(path, nil, 25.3, 16.2, 25.1, 16.6, 25, 17)
//			CGPathAddCurveToPoint(path, nil, 24.8, 16.9, 24.6, 16.8, 24.3, 16.6)
//			CGPathAddCurveToPoint(path, nil, 24.3, 16.6, 16.3, 11.5, 7.6, 2.9)
//			CGPathAddCurveToPoint(path, nil, 7.4, 2.7, 12.2, 9.9, 17.8, 15.7)
//			CGPathAddCurveToPoint(path, nil, 15.2, 14.2, 7.9, 9, 3.4, 4.8)
//			CGPathAddCurveToPoint(path, nil, 4, 5.7, 4.6, 6.6, 5.4, 7.5)
//			CGPathAddCurveToPoint(path, nil, 9.2, 12.4, 14.2, 18.4, 20.2, 23)
//			CGPathAddCurveToPoint(path, nil, 16, 25.6, 10, 25.8, 4.1, 23)
//			CGPathAddCurveToPoint(path, nil, 2.6, 22.3, 1.3, 21.5, 0, 20.5)
//			CGPathAddCurveToPoint(path, nil, 2.5, 24.5, 6.4, 28, 11.1, 30)
//			CGPathAddCurveToPoint(path, nil, 16.7, 32.4, 22.3, 32.2, 26.4, 30)
//			CGPathAddLineToPoint(path, nil, 26.4, 30)
//			CGPathAddCurveToPoint(path, nil, 28.1, 28.9, 32.7, 27.2, 35, 31.7)
//			CGPathAddCurveToPoint(path, nil, origin.x + 2.9, origin.y + 10.3, origin.x + 4, origin.y + 5, origin.x, origin.y)
//			CGPathCloseSubpath(path)
//
//			print(CGPathGetBoundingBox(path))
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}

//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
//
//			// 36x33
//			// x10.3 y19.4 maxx 45.3 maxy 51.1
//			// (10.3, 19.4, 36.5, 32.6)
//			let scaleH = size.width / 36.5
//			let scaleV = size.height / 32.6
//			//			CGContextScaleCTM(context, scaleH, scaleV)
//			//			CGContextTranslateCTM(context, -10.3, -19.4)
//
//			//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			let origin = CGPointMake(32.5 * scaleH, 22.3 * scaleV)
//
//			CGPathMoveToPoint(path, nil, origin.x, origin.y)
//			CGPathAddCurveToPoint(path, nil, origin.x, origin.y, origin.x, origin.y, origin.x, origin.y)
//			var cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y - 0.2 * scaleV, cp.x + 0.1 * scaleH, cp.y - 0.4, cp.x + 0.1 * scaleH, cp.y - 0.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 2 * scaleH, cp.y - 7.8 * scaleV, cp.x - 2.8 * scaleH, cp.y - 17 * scaleV, cp.x - 10.9 * scaleH, cp.y - 21.8 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.5 * scaleH, cp.y + 4.8 * scaleV, cp.x + 5.1 * scaleH, cp.y + 10.6 * scaleV, cp.x + 3.7 * scaleH, cp.y + 15.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.1 * scaleH, cp.y + 0.5 * scaleV, cp.x - 0.3 * scaleH, cp.y + 0.9 * scaleV, cp.x - 0.4 * scaleH, cp.y + 1.3 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2 * scaleH, cp.y - 0.1 * scaleV, cp.x - 0.4 * scaleH, cp.y - 0.2 * scaleV, cp.x - 0.7 * scaleH, cp.y - 0.4 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y, cp.x - 8 * scaleH, cp.y - 5 * scaleV, cp.x - 16.7 * scaleH, cp.y - 13.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2 * scaleH, cp.y - 0.2 * scaleV, cp.x + 4.6 * scaleH, cp.y + 7 * scaleV, cp.x + 10.2 * scaleH, cp.y + 12.8 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x - 2.6 * scaleH, cp.y - 1.5 * scaleV, cp.x - 9.9 * scaleH, cp.y - 6.7 * scaleV, cp.x - 14.4 * scaleH, cp.y - 10.9 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 0.6 * scaleH, cp.y + 0.9 * scaleV, cp.x + 1.2 * scaleH, cp.y + 1.8 * scaleV, cp.x + 2 * scaleH, cp.y + 2.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.8 * scaleH, cp.y + 4.9 * scaleV, cp.x + 8.8 * scaleH, cp.y + 10.9 * scaleV, cp.x + 14.8 * scaleH, cp.y + 15.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x - 4.2 * scaleH, cp.y + 2.6 * scaleV, cp.x - 10.2 * scaleH, cp.y + 2.8 * scaleV, cp.x - 16.1 * scaleH, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x - 1.5 * scaleH, cp.y - 0.7 * scaleV, cp.x - 2.8 * scaleH, cp.y - 1.5 * scaleV, cp.x - 4.1 * scaleH, cp.y - 2.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 2.5 * scaleH, cp.y + 4 * scaleV, cp.x + 6.4 * scaleH, cp.y + 7.5 * scaleV, cp.x + 11.1 * scaleH, cp.y + 9.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 5.6 * scaleH, cp.y + 2.4 * scaleV, cp.x + 11.2 * scaleH, cp.y + 2.2 * scaleV, cp.x + 15.3 * scaleH, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddLineToPoint(path, nil, cp.x, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, cp.x + 1.7 * scaleH, cp.y - 1.1 * scaleV, cp.x + 6.3 * scaleH, cp.y - 2.8 * scaleV, cp.x + 8.6 * scaleH, cp.y + 1.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//
//			CGPathAddCurveToPoint(path, nil, origin.x + 2.9 * scaleH, origin.y + 10.3 * scaleV, origin.x + 4 * scaleH, origin.y + 5 * scaleV, origin.x, origin.y)
//			CGPathCloseSubpath(path)
//
//			print(CGPathGetBoundingBox(path))
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//		
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}

//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(36, 32), flipped: true) { (context, size) in
//
//			// 36x33
//			// x10.3 y19.4 maxx 45.3 maxy 51.1
//			// (10.3, 19.4, 36.5, 32.6)
//			let scaleH = size.width / 36.5
//			let scaleV = size.height / 32.6
//			CGContextScaleCTM(context, scaleH, scaleV)
//			CGContextTranslateCTM(context, -10.3, -19.4)
//
//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			var minX: CGFloat = 1000
//			var minY: CGFloat = 1000
//			var maxX: CGFloat = -1000
//			var maxY: CGFloat = -1000
//			let update: (CGPoint) -> () = {
//				minX = min($0.x, minX)
//				minY = min($0.y, minY)
//				maxX = max($0.x, maxX)
//				maxY = max($0.y, maxY)
//			}
//
//			CGPathMoveToPoint(path, nil, 42.8, 41.7)
//			CGPathAddCurveToPoint(path, nil, 42.8, 41.7, 42.8, 41.7, 42.8, 41.7)
//			var cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y - 0.2, cp.x + 0.1, cp.y - 0.4, cp.x + 0.1, cp.y - 0.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2, cp.y - 7.8, cp.x - 2.8, cp.y - 17, cp.x - 10.9, cp.y - 21.8)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.5, cp.y + 4.8, cp.x + 5.1, cp.y + 10.6, cp.x + 3.7, cp.y + 15.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.1, cp.y + 0.5, cp.x - 0.3, cp.y + 0.9, cp.x - 0.4, cp.y + 1.3)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.1, cp.x - 0.4, cp.y - 0.2, cp.x - 0.7, cp.y - 0.4)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y, cp.x - 8, cp.y - 5, cp.x - 16.7, cp.y - 13.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.2, cp.x + 4.6, cp.y + 7, cp.x + 10.2, cp.y + 12.8)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 2.6, cp.y - 1.5, cp.x - 9.9, cp.y - 6.7, cp.x - 14.4, cp.y - 10.9)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 0.6, cp.y + 0.9, cp.x + 1.2, cp.y + 1.8, cp.x + 2, cp.y + 2.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.8, cp.y + 4.9, cp.x + 8.8, cp.y + 10.9, cp.x + 14.8, cp.y + 15.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 4.2, cp.y + 2.6, cp.x - 10.2, cp.y + 2.8, cp.x - 16.1, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 1.5, cp.y - 0.7, cp.x - 2.8, cp.y - 1.5, cp.x - 4.1, cp.y - 2.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2.5, cp.y + 4, cp.x + 6.4, cp.y + 7.5, cp.x + 11.1, cp.y + 9.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 5.6, cp.y + 2.4, cp.x + 11.2, cp.y + 2.2, cp.x + 15.3, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddLineToPoint(path, nil, cp.x, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 1.7, cp.y - 1.1, cp.x + 6.3, cp.y - 2.8, cp.x + 8.6, cp.y + 1.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, 45.7, 52, 46.8, 46.7, 42.8, 41.7)
//			CGPathCloseSubpath(path)
//
//			print(CGPathGetBoundingBox(path))
//			print(minX, minY, maxX, maxY)
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}
//
//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
//
//			// 36x33
//			// x10.3 y19.4 maxx 45.3 maxy 51.1
//			// (10.3, 19.4, 36.5, 32.6)
//			let scaleH = size.width / 36.5
//			let scaleV = size.height / 32.6
//			CGContextScaleCTM(context, scaleH, scaleV)
//			CGContextTranslateCTM(context, -10.3, -19.4)
//
//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			var minX: CGFloat = 1000
//			var minY: CGFloat = 1000
//			var maxX: CGFloat = -1000
//			var maxY: CGFloat = -1000
//			let update: (CGPoint) -> () = {
//				minX = min($0.x, minX)
//				minY = min($0.y, minY)
//				maxX = max($0.x, maxX)
//				maxY = max($0.y, maxY)
//			}
//
//			CGPathMoveToPoint(path, nil, 42.8, 41.7)
//			CGPathAddCurveToPoint(path, nil, 42.8, 41.7, 42.8, 41.7, 42.8, 41.7)
//			var cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y - 0.2, cp.x + 0.1, cp.y - 0.4, cp.x + 0.1, cp.y - 0.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2, cp.y - 7.8, cp.x - 2.8, cp.y - 17, cp.x - 10.9, cp.y - 21.8)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.5, cp.y + 4.8, cp.x + 5.1, cp.y + 10.6, cp.x + 3.7, cp.y + 15.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.1, cp.y + 0.5, cp.x - 0.3, cp.y + 0.9, cp.x - 0.4, cp.y + 1.3)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.1, cp.x - 0.4, cp.y - 0.2, cp.x - 0.7, cp.y - 0.4)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y, cp.x - 8, cp.y - 5, cp.x - 16.7, cp.y - 13.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.2, cp.x + 4.6, cp.y + 7, cp.x + 10.2, cp.y + 12.8)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 2.6, cp.y - 1.5, cp.x - 9.9, cp.y - 6.7, cp.x - 14.4, cp.y - 10.9)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 0.6, cp.y + 0.9, cp.x + 1.2, cp.y + 1.8, cp.x + 2, cp.y + 2.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.8, cp.y + 4.9, cp.x + 8.8, cp.y + 10.9, cp.x + 14.8, cp.y + 15.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 4.2, cp.y + 2.6, cp.x - 10.2, cp.y + 2.8, cp.x - 16.1, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 1.5, cp.y - 0.7, cp.x - 2.8, cp.y - 1.5, cp.x - 4.1, cp.y - 2.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2.5, cp.y + 4, cp.x + 6.4, cp.y + 7.5, cp.x + 11.1, cp.y + 9.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 5.6, cp.y + 2.4, cp.x + 11.2, cp.y + 2.2, cp.x + 15.3, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddLineToPoint(path, nil, cp.x, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 1.7, cp.y - 1.1, cp.x + 6.3, cp.y - 2.8, cp.x + 8.6, cp.y + 1.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, 45.7, 52, 46.8, 46.7, 42.8, 41.7)
//			CGPathCloseSubpath(path)
//
//			print(CGPathGetBoundingBox(path))
//			print(minX, minY, maxX, maxY)
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}

//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
//
//			// 36x33
//			// x10.3 y19.4 maxx 45.3 maxy 51.1
//			let scaleH = size.width / 36.0
//			let scaleV = size.height / 32.0
////			CGContextTranslateCTM(context, -10 * scaleH, -19 * scaleV)
////			CGContextScaleCTM(context, scaleH, scaleV)
//
//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			var minX: CGFloat = 1000
//			var minY: CGFloat = 1000
//			var maxX: CGFloat = -1000
//			var maxY: CGFloat = -1000
//			let update: (CGPoint) -> () = {
//				minX = min($0.x, minX)
//				minY = min($0.y, minY)
//				maxX = max($0.x, maxX)
//				maxY = max($0.y, maxY)
//			}
//
//			CGPathMoveToPoint(path, nil, 42.8, 41.7)
//			CGPathAddCurveToPoint(path, nil, 42.8, 41.7, 42.8, 41.7, 42.8, 41.7)
//			var cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y - 0.2, cp.x + 0.1, cp.y - 0.4, cp.x + 0.1, cp.y - 0.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2, cp.y - 7.8, cp.x - 2.8, cp.y - 17, cp.x - 10.9, cp.y - 21.8)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.5, cp.y + 4.8, cp.x + 5.1, cp.y + 10.6, cp.x + 3.7, cp.y + 15.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.1, cp.y + 0.5, cp.x - 0.3, cp.y + 0.9, cp.x - 0.4, cp.y + 1.3)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.1, cp.x - 0.4, cp.y - 0.2, cp.x - 0.7, cp.y - 0.4)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y, cp.x - 8, cp.y - 5, cp.x - 16.7, cp.y - 13.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.2, cp.x + 4.6, cp.y + 7, cp.x + 10.2, cp.y + 12.8)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 2.6, cp.y - 1.5, cp.x - 9.9, cp.y - 6.7, cp.x - 14.4, cp.y - 10.9)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 0.6, cp.y + 0.9, cp.x + 1.2, cp.y + 1.8, cp.x + 2, cp.y + 2.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.8, cp.y + 4.9, cp.x + 8.8, cp.y + 10.9, cp.x + 14.8, cp.y + 15.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 4.2, cp.y + 2.6, cp.x - 10.2, cp.y + 2.8, cp.x - 16.1, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x - 1.5, cp.y - 0.7, cp.x - 2.8, cp.y - 1.5, cp.x - 4.1, cp.y - 2.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2.5, cp.y + 4, cp.x + 6.4, cp.y + 7.5, cp.x + 11.1, cp.y + 9.5)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 5.6, cp.y + 2.4, cp.x + 11.2, cp.y + 2.2, cp.x + 15.3, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddLineToPoint(path, nil, cp.x, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, cp.x + 1.7, cp.y - 1.1, cp.x + 6.3, cp.y - 2.8, cp.x + 8.6, cp.y + 1.7)
//			cp = CGPathGetCurrentPoint(path)
//			update(cp)
//			CGPathAddCurveToPoint(path, nil, 45.7, 52, 46.8, 46.7, 42.8, 41.7)
//			CGPathCloseSubpath(path)
//
//			print(minX, minY, maxX, maxY)
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}

//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
//
//			// 36x33
//			CGContextTranslateCTM(context, -10, -19)
//			let scaleH = size.width / 36.0
//			let scaleV = size.height / 32.0
//
//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			CGPathMoveToPoint(path, nil, 42.8, 41.7)
//			CGPathAddCurveToPoint(path, nil, 42.8, 41.7, 42.8, 41.7, 42.8, 41.7)
//			var cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y - 0.2 * scaleV, cp.x + 0.1 * scaleH, cp.y - 0.4 * scaleV, cp.x + 0.1 * scaleH, cp.y - 0.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2 * scaleH, cp.y - 7.8 * scaleV, cp.x - 2.8 * scaleH, cp.y - 17 * scaleV, cp.x - 10.9 * scaleH, cp.y - 21.8 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.5 * scaleH, cp.y + 4.8 * scaleV, cp.x + 5.1 * scaleH, cp.y + 10.6 * scaleV, cp.x + 3.7 * scaleH, cp.y + 15.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.1 * scaleH, cp.y + 0.5 * scaleV, cp.x - 0.3 * scaleH, cp.y + 0.9 * scaleV, cp.x - 0.4 * scaleH, cp.y + 1.3 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2 * scaleH, cp.y - 0.1 * scaleV, cp.x - 0.4 * scaleH, cp.y - 0.2 * scaleV, cp.x - 0.7 * scaleH, cp.y - 0.4 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y, cp.x - 8 * scaleH, cp.y - 5 * scaleV, cp.x - 16.7 * scaleH, cp.y - 13.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2 * scaleH, cp.y - 0.2 * scaleV, cp.x + 4.6 * scaleH, cp.y + 7 * scaleV, cp.x + 10.2 * scaleH, cp.y + 12.8 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 2.6 * scaleH, cp.y - 1.5 * scaleV, cp.x - 9.9 * scaleH, cp.y - 6.7 * scaleV, cp.x - 14.4 * scaleH, cp.y - 10.9 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 0.6 * scaleH, cp.y + 0.9 * scaleV, cp.x + 1.2 * scaleH, cp.y + 1.8 * scaleV, cp.x + 2 * scaleH, cp.y + 2.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.8 * scaleH, cp.y + 4.9 * scaleV, cp.x + 8.8 * scaleH, cp.y + 10.9 * scaleV, cp.x + 14.8 * scaleH, cp.y + 15.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 4.2 * scaleH, cp.y + 2.6 * scaleV, cp.x - 10.2 * scaleH, cp.y + 2.8 * scaleV, cp.x - 16.1 * scaleH, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 1.5 * scaleH, cp.y - 0.7 * scaleV, cp.x - 2.8 * scaleH, cp.y - 1.5 * scaleV, cp.x - 4.1 * scaleH, cp.y - 2.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2.5 * scaleH, cp.y + 4 * scaleV, cp.x + 6.4 * scaleH, cp.y + 7.5 * scaleV, cp.x + 11.1 * scaleH, cp.y + 9.5 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 5.6 * scaleH, cp.y + 2.4 * scaleV, cp.x + 11.2 * scaleH, cp.y + 2.2 * scaleV, cp.x + 15.3 * scaleH, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddLineToPoint(path, nil, cp.x, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 1.7 * scaleH, cp.y - 1.1 * scaleV, cp.x + 6.3 * scaleH, cp.y - 2.8 * scaleV, cp.x + 8.6, cp.y + 1.7 * scaleV)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, 45.7, 52, 46.8, 46.7, 42.8, 41.7)
//			CGPathCloseSubpath(path)
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}

//	func testFlippedImageGeneration2() {
//		let image = try! CGImage.imageWithSize(CGSizeMake(100, 100), flipped: true) { (context, size) in
//			let backgroundColor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor2)
//			CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
//
//			let path = CGPathCreateMutable()
//			CGPathGetCurrentPoint(path)
//
//			CGPathMoveToPoint(path, nil, 42.8, 41.7)
//			CGPathAddCurveToPoint(path, nil, 42.8, 41.7, 42.8, 41.7, 42.8, 41.7)
//			var cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y - 0.2, cp.x + 0.1, cp.y - 0.4, cp.x + 0.1, cp.y - 0.5)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2, cp.y - 7.8, cp.x - 2.8, cp.y - 17, cp.x - 10.9, cp.y - 21.8)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.5, cp.y + 4.8, cp.x + 5.1, cp.y + 10.6, cp.x + 3.7, cp.y + 15.7)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.1, cp.y + 0.5, cp.x - 0.3, cp.y + 0.9, cp.x - 0.4, cp.y + 1.3)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.1, cp.x - 0.4, cp.y - 0.2, cp.x - 0.7, cp.y - 0.4)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x, cp.y, cp.x - 8, cp.y - 5, cp.x - 16.7, cp.y - 13.7)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 0.2, cp.y - 0.2, cp.x + 4.6, cp.y + 7, cp.x + 10.2, cp.y + 12.8)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 2.6, cp.y - 1.5, cp.x - 9.9, cp.y - 6.7, cp.x - 14.4, cp.y - 10.9)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 0.6, cp.y + 0.9, cp.x + 1.2, cp.y + 1.8, cp.x + 2, cp.y + 2.7)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 3.8, cp.y + 4.9, cp.x + 8.8, cp.y + 10.9, cp.x + 14.8, cp.y + 15.5)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 4.2, cp.y + 2.6, cp.x - 10.2, cp.y + 2.8, cp.x - 16.1, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x - 1.5, cp.y - 0.7, cp.x - 2.8, cp.y - 1.5, cp.x - 4.1, cp.y - 2.5)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 2.5, cp.y + 4, cp.x + 6.4, cp.y + 7.5, cp.x + 11.1, cp.y + 9.5)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 5.6, cp.y + 2.4, cp.x + 11.2, cp.y + 2.2, cp.x + 15.3, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddLineToPoint(path, nil, cp.x, cp.y)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, cp.x + 1.7, cp.y - 1.1, cp.x + 6.3, cp.y - 2.8, cp.x + 8.6, cp.y + 1.7)
//			cp = CGPathGetCurrentPoint(path)
//			CGPathAddCurveToPoint(path, nil, 45.7, 52, 46.8, 46.7, 42.8, 41.7)
//			CGPathCloseSubpath(path)
//
//			CGContextAddPath(context, path)
//			let backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 1, 1])
//			CGContextSetFillColorWithColor(context, backgroundColor)
//			CGContextFillPath(context)
//		}
//
//		expect(image).to(recordReferenceImageNamed("Boo"))
//	}

}
