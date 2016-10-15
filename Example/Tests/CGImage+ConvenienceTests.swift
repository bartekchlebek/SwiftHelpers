import XCTest
import Nimble
import SwiftHelpers

final class CGImage_ConvenienceTests: XCTestCase {

	private let imageForTests = {
		return try! CGImage.image(withSize: CGSize(width: 100, height: 50)) { (context, size) in
			// blue background
			let backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 1, 1])
			context.setFillColor(backgroundColor!)
			context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

			// red oval
			let ovalPath = CGPath(ellipseIn: CGRect(x: 0, y: 40, width: 50, height: 20), transform: nil)
			context.addPath(ovalPath)
			let color = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 1])
			context.setFillColor(color!)
			context.fillPath()
		}
	}()

	func testConvenienceProperties() {
		let image = self.imageForTests
		expect(image.size) == CGSize(width: CGFloat(image.width), height: CGFloat(image.height))
	}
	
}
