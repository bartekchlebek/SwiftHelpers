import CoreGraphics

public extension CGImage {
	private enum Error: Swift.Error {
		case contextSetupFailed
		case gettingImageFromContextFailed
	}

	static func image(withSize size: CGSize,
	                  flipped: Bool = CGContext.isCoordinateSpaceFlippedByDefault,
	                  drawRectBlock: @noescape (CGContext, CGSize) -> ()) throws -> CGImage {

		guard let context = CGContext.deviceContext(withSize: size, flipped: flipped)
			else { throw Error.contextSetupFailed }
		drawRectBlock(context, size)
		guard let image = context.makeImage() else { throw Error.gettingImageFromContextFailed }
		return image
	}
}

