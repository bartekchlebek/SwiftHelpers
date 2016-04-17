import XCTest
import Nimble
import SwiftHelpers

class CGImage_ImageEffects: XCTestCase {

	private func swiftLogo(withTansparency withTansparency: Bool) -> CGImage {
		let logo = CGImage.swiftLogoWithWidth(512)

		if withTansparency { return logo }

		return try! CGImage.imageWithSize(logo.size, flipped: false) { (context, size) in
			let drawRect = CGRectMake(0, 0, size.width, size.height)
			let color = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 1, 0, 1])

			CGContextSetFillColorWithColor(context, color)
			CGContextFillRect(context, drawRect)
			CGContextDrawImage(context, drawRect, logo)
		}
	}

	func testOwnImplementation() {
		let swiftLogo = self.swiftLogo(withTansparency: false)

		let blurRadius: CGFloat = 30
		let blurredLogo = try! swiftLogo.imageByApplyingBlurWithRadius(blurRadius)

		let uiimage = UIImage(CGImage: swiftLogo)
		let appleBlur = uiimage.applyBlurWithRadius(blurRadius, tintColor: nil, saturationDeltaFactor: 1)

		expect(appleBlur!.CGImage!).to(recordReferenceImageNamed("own"))
		expect(blurredLogo).to(recordReferenceImageNamed("apple"))
	}

	func testAppleImplementation() {
	}

}
