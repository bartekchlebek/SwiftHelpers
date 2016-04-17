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

	func testBlurringImageWithoutTransparency() {
		let swiftLogo = self.swiftLogo(withTansparency: false)
		let blurredLogo = try! swiftLogo.imageByApplyingBlurWithRadius(30)
		expect(blurredLogo).to(matchReferenceImageNamed("BlurWithoutTransparency"))
	}

	func testBlurringImageWithTransparency() {
		let swiftLogo = self.swiftLogo(withTansparency: true)
		let blurredLogo = try! swiftLogo.imageByApplyingBlurWithRadius(30)
		expect(blurredLogo).to(matchReferenceImageNamed("BlurWithTransparency"))
	}

	func testBlurringImageWithoutTransparencyIdenticalToAppleImageEffects() {
		let swiftLogo = self.swiftLogo(withTansparency: false)

		let blurRadius: CGFloat = 30
		let blurredLogo = try! swiftLogo.imageByApplyingBlurWithRadius(blurRadius)
		let appleBlur = UIImage(CGImage: swiftLogo).applyBlurWithRadius(blurRadius)

		expect(blurredLogo.looksIdenticalTo(appleBlur!.CGImage!)).to(beTruthy())
	}

}
