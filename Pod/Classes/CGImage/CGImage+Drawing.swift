import CoreGraphics

public typealias DrawRectBlock = (CGContextRef, CGSize) throws -> ()

public extension CGImage {
	private enum Error: ErrorType {
		case ContextSetupFailed
		case GettingImageFromContextFailed
	}

	static func imageWithSize(size: CGSize,
	                          flipped: Bool = CGContext.isCoordinateSpaceFlippedByDefault,
	                          @noescape drawRectBlock: DrawRectBlock) throws -> CGImage {

		guard let context = CGContext.deviceContextWithSize(size, flipped: flipped) else { throw Error.ContextSetupFailed }
		try drawRectBlock(context, size)
		guard let image = CGBitmapContextCreateImage(context) else { throw Error.GettingImageFromContextFailed }
		return image
	}
}

