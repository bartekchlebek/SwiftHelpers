import CoreGraphics

extension CGImage {
	public var width: Int { return CGImageGetWidth(self) }
	public var height: Int { return CGImageGetHeight(self) }
	public var size: CGSize { return CGSizeMake(CGFloat(self.width), CGFloat(self.height)) }
	public var bytesPerRow: Int { return CGImageGetBytesPerRow(self) }
	public var bitsPerComponent: Int { return CGImageGetBitsPerComponent(self) }
	public var bitsPerPixel: Int { return CGImageGetBitsPerPixel(self) }
	public var colorSpace: CGColorSpace? { return CGImageGetColorSpace(self) }
}
