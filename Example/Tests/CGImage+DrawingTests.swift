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
			context.translateBy(x: (size.width - badgeSize.width) * 0.5, y: (size.height - badgeSize.height) * 0.5)

			let badgePath = CGMutablePath()
			let badgeRect = CGRect(x: 0, y: 0, width: badgeSize.width, height: badgeSize.height)
			let cornerRadius = badgeSize.width * 0.25
			badgePath.addRoundedRect(in: badgeRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
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

			context.translateBy(x: swiftLogoRect.origin.x, y: swiftLogoRect.origin.y)

			let horizontalScale = swiftLogoRect.width / 36.5
			let verticalScale = swiftLogoRect.height / 32.6
			context.scaleBy(x: horizontalScale, y: verticalScale)

			let path = CGMutablePath()

			path.move(to: CGPoint(x: 32.5, y: 22.3))
			path.addCurve(to: CGPoint(x: 32.5, y: 22.3), control1: CGPoint(x: 32.5, y: 22.3), control2: CGPoint(x: 32.5, y: 22.3))
			path.addCurve(to: CGPoint(x: 32.6, y: 21.8), control1: CGPoint(x: 32.5, y: 22.1), control2: CGPoint(x: 32.6, y: 21.9))
			path.addCurve(to: CGPoint(x: 21.7, y: 0), control1: CGPoint(x: 34.6, y: 14), control2: CGPoint(x: 29.8, y: 4.8))
			path.addCurve(to: CGPoint(x: 25.4, y: 15.7), control1: CGPoint(x: 25.2, y: 4.8), control2: CGPoint(x: 26.8, y: 10.6))
			path.addCurve(to: CGPoint(x: 25, y: 17), control1: CGPoint(x: 25.3, y: 16.2), control2: CGPoint(x: 25.1, y: 16.6))
			path.addCurve(to: CGPoint(x: 24.3, y: 16.6), control1: CGPoint(x: 24.8, y: 16.9), control2: CGPoint(x: 24.6, y: 16.8))
			path.addCurve(to: CGPoint(x: 7.6, y: 2.9), control1: CGPoint(x: 24.3, y: 16.6), control2: CGPoint(x: 16.3, y: 11.5))
			path.addCurve(to: CGPoint(x: 17.8, y: 15.7), control1: CGPoint(x: 7.4, y: 2.7), control2: CGPoint(x: 12.2, y: 9.9))
			path.addCurve(to: CGPoint(x: 3.4, y: 4.8), control1: CGPoint(x: 15.2, y: 14.2), control2: CGPoint(x: 7.9, y: 9))
			path.addCurve(to: CGPoint(x: 5.4, y: 7.5), control1: CGPoint(x: 4, y: 5.7), control2: CGPoint(x: 4.6, y: 6.6))
			path.addCurve(to: CGPoint(x: 20.2, y: 23), control1: CGPoint(x: 9.2, y: 12.4), control2: CGPoint(x: 14.2, y: 18.4))
			path.addCurve(to: CGPoint(x: 4.1, y: 23), control1: CGPoint(x: 16, y: 25.6), control2: CGPoint(x: 10, y: 25.8))
			path.addCurve(to: CGPoint(x: 0, y: 20.5), control1: CGPoint(x: 2.6, y: 22.3), control2: CGPoint(x: 1.3, y: 21.5))
			path.addCurve(to: CGPoint(x: 11.1, y: 30), control1: CGPoint(x: 2.5, y: 24.5), control2: CGPoint(x: 6.4, y: 28))
			path.addCurve(to: CGPoint(x: 26.4, y: 30), control1: CGPoint(x: 16.7, y: 32.4), control2: CGPoint(x: 22.3, y: 32.2))
			path.addLine(to: CGPoint(x: 26.4, y: 30))
			path.addCurve(to: CGPoint(x: 35, y: 31.7), control1: CGPoint(x: 28.1, y: 28.9), control2: CGPoint(x: 32.7, y: 27.2))
			path.addCurve(to: CGPoint(x: 32.5, y: 22.3), control1: CGPoint(x: 35.4, y: 32.6), control2: CGPoint(x: 36.5, y: 27.3))
			path.closeSubpath()

			context.addPath(path)
			let backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 1, 1, 1])
			context.setFillColor(backgroundColor!)
			context.fillPath()
		}

		expect(image).to(matchReferenceImageNamed("SwiftLogo"))
	}
	
}
