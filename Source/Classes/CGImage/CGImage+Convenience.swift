import CoreGraphics

public extension CGImage {
	var size: CGSize { return CGSize(width: CGFloat(self.width), height: CGFloat(self.height)) }
}
