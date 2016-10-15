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
		self.translateBy(x: 0, y: CGFloat(self.height))
		self.scaleBy(x: 1, y: -1)
	}

	static func deviceContext(withSize size: CGSize,
	                          flipped: Bool = CGContext.isCoordinateSpaceFlippedByDefault) -> CGContext? {

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let context = CGContext(data: nil,
		                        width: Int(size.width),
		                        height: Int(size.height),
		                        bitsPerComponent: 8,
		                        bytesPerRow: 0,
		                        space: colorSpace,
		                        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

		if flipped {
			context?.flipCoordinateSpace()
		}

		return context
	}
}
