import CoreGraphics

extension CGContext {
	static var isCoordinateSpaceFlippedByDefault: Bool {
		#if os(iOS)
			return true
		#elseif os(OSX)
			return false
		#endif
	}

	public func flipCoordinateSpace() {
		CGContextTranslateCTM(self, 0, CGFloat(self.height))
		CGContextScaleCTM(self, 1, -1)
	}

	static func deviceContextWithSize(size: CGSize,
	                                  flipped: Bool = CGContext.isCoordinateSpaceFlippedByDefault) -> CGContext? {

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let context = CGBitmapContextCreate(
			nil,
			Int(size.width),
			Int(size.height),
			8,
			0,
			colorSpace,
			CGImageAlphaInfo.PremultipliedFirst.rawValue
		)

		if flipped {
			context?.flipCoordinateSpace()
		}

		return context
	}
}

private extension CGContext {
	var width: Int {
		guard self.isBitmapContext else { preconditionFailure("Cannot get width of a non-bitmap CGContext") }
		return CGBitmapContextGetWidth(self)
	}

	var height: Int {
		guard self.isBitmapContext else { preconditionFailure("Cannot get height of a non-bitmap CGContext") }
		return CGBitmapContextGetHeight(self)
	}
}

private extension CGContext {
	var isBitmapContext: Bool {
		return (CGBitmapContextGetBitmapInfo(self).rawValue != 0)
	}
}


