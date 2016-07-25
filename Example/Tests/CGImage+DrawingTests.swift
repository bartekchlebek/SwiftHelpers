import XCTest
import Nimble
import SwiftHelpers

final class CGImage_DrawingTests: XCTestCase {

	func drawTestImageInContext(_ context: CGContext, size: CGSize) {
		// blue background
		let backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 1, 1])
		context.setFillColor(backgroundColor!)
		context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

		// red oval
		let ovalPath = CGPath(ellipseIn: CGRect(x: 0, y: 50, width: 50, height: 50), transform: nil)
		context.addPath(ovalPath)
		let color = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 1])
		context.setFillColor(color!)
		context.fillPath()
	}

	func testImageGeneration() {
		let image = try! CGImage.image(withSize: CGSize(width: 100, height: 100), flipped: false) { (context, size) in
			drawTestImageInContext(context, size: size)
		}
		expect(image).to(matchReferenceImageNamed("Red50x50OvalInTheTopLeftOfABlue100x100Square"))
	}

	func testFlippedImageGeneration() {
		let image = try! CGImage.image(withSize: CGSize(width: 100, height: 100), flipped: true) { (context, size) in
			drawTestImageInContext(context, size: size)
		}
		expect(image).to(matchReferenceImageNamed("Red50x50OvalInTheBottomLeftOfABlue100x100Square"))
	}

	func testSwiftLogo() {
		let image = try! CGImage.image(withSize: CGSize(width: 256, height: 256)) { (context, size) in

			let shorterSide = min(size.width, size.height)
			let badgeSize = CGSize(width: shorterSide, height: shorterSide)
			context.translate(x: (size.width - badgeSize.width) * 0.5, y: (size.height - badgeSize.height) * 0.5)

			let badgePath = CGMutablePath()
			let badgeRect = CGRect(x: 0, y: 0, width: badgeSize.width, height: badgeSize.height)
			let cornerRadius = badgeSize.width * 0.25
			badgePath.addRoundedRect(nil, rect: badgeRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
			context.addPath(badgePath)

			let badgeColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [239 / 255, 81 / 255, 56 / 255, 1])
			context.setFillColor(badgeColor!)
			context.fillPath()

			let swiftLogoAspectRatio: CGFloat = 36.5 / 32.6
			let swiftLogoWidth = badgeSize.width * 0.75
			let swiftLogoHeight = swiftLogoWidth / swiftLogoAspectRatio
			let swiftLogoRect = CGRect(x: (badgeSize.width - swiftLogoWidth) * 0.5,
			                           y: (badgeSize.height - swiftLogoHeight) * 0.5,
			                           width: swiftLogoWidth,
			                           height: swiftLogoHeight)

			context.translate(x: swiftLogoRect.origin.x, y: swiftLogoRect.origin.y)

			let horizontalScale = swiftLogoRect.width / 36.5
			let verticalScale = swiftLogoRect.height / 32.6
			context.scale(x: horizontalScale, y: verticalScale)

			let path = CGMutablePath()

			path.moveTo(nil, x: 32.5, y: 22.3)
			path.addCurve(nil, cp1x: 32.5, cp1y: 22.3, cp2x: 32.5, cp2y: 22.3, endingAtX: 32.5, y: 22.3)
			path.addCurve(nil, cp1x: 32.5, cp1y: 22.1, cp2x: 32.6, cp2y: 21.9, endingAtX: 32.6, y: 21.8)
			path.addCurve(nil, cp1x: 34.6, cp1y: 14, cp2x: 29.8, cp2y: 4.8, endingAtX: 21.7, y: 0)
			path.addCurve(nil, cp1x: 25.2, cp1y: 4.8, cp2x: 26.8, cp2y: 10.6, endingAtX: 25.4, y: 15.7)
			path.addCurve(nil, cp1x: 25.3, cp1y: 16.2, cp2x: 25.1, cp2y: 16.6, endingAtX: 25, y: 17)
			path.addCurve(nil, cp1x: 24.8, cp1y: 16.9, cp2x: 24.6, cp2y: 16.8, endingAtX: 24.3, y: 16.6)
			path.addCurve(nil, cp1x: 24.3, cp1y: 16.6, cp2x: 16.3, cp2y: 11.5, endingAtX: 7.6, y: 2.9)
			path.addCurve(nil, cp1x: 7.4, cp1y: 2.7, cp2x: 12.2, cp2y: 9.9, endingAtX: 17.8, y: 15.7)
			path.addCurve(nil, cp1x: 15.2, cp1y: 14.2, cp2x: 7.9, cp2y: 9, endingAtX: 3.4, y: 4.8)
			path.addCurve(nil, cp1x: 4, cp1y: 5.7, cp2x: 4.6, cp2y: 6.6, endingAtX: 5.4, y: 7.5)
			path.addCurve(nil, cp1x: 9.2, cp1y: 12.4, cp2x: 14.2, cp2y: 18.4, endingAtX: 20.2, y: 23)
			path.addCurve(nil, cp1x: 16, cp1y: 25.6, cp2x: 10, cp2y: 25.8, endingAtX: 4.1, y: 23)
			path.addCurve(nil, cp1x: 2.6, cp1y: 22.3, cp2x: 1.3, cp2y: 21.5, endingAtX: 0, y: 20.5)
			path.addCurve(nil, cp1x: 2.5, cp1y: 24.5, cp2x: 6.4, cp2y: 28, endingAtX: 11.1, y: 30)
			path.addCurve(nil, cp1x: 16.7, cp1y: 32.4, cp2x: 22.3, cp2y: 32.2, endingAtX: 26.4, y: 30)
			path.addLineTo(nil, x: 26.4, y: 30)
			path.addCurve(nil, cp1x: 28.1, cp1y: 28.9, cp2x: 32.7, cp2y: 27.2, endingAtX: 35, y: 31.7)
			path.addCurve(nil, cp1x: 35.4, cp1y: 32.6, cp2x: 36.5, cp2y: 27.3, endingAtX: 32.5, y: 22.3)
			path.closeSubpath()

			context.addPath(path)
			let backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 1, 1, 1])
			context.setFillColor(backgroundColor!)
			context.fillPath()
		}

		expect(image).to(matchReferenceImageNamed("SwiftLogo"))
	}
	
}
