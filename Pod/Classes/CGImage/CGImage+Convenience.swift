import CoreGraphics

public extension CGImage {
	var width: Int { return CGImageGetWidth(self) }
	var height: Int { return CGImageGetHeight(self) }
	var size: CGSize { return CGSizeMake(CGFloat(self.width), CGFloat(self.height)) }
	var bytesPerRow: Int { return CGImageGetBytesPerRow(self) }
	var bitsPerComponent: Int { return CGImageGetBitsPerComponent(self) }
	var bitsPerPixel: Int { return CGImageGetBitsPerPixel(self) }
	var colorSpace: CGColorSpace? { return CGImageGetColorSpace(self) }
}
