import CoreGraphics
import Accelerate

private extension vImage_Buffer {
	init(context: CGContext) {
		let data = CGBitmapContextGetData(context)
		let width = vImagePixelCount(CGBitmapContextGetWidth(context))
		let height = vImagePixelCount(CGBitmapContextGetHeight(context))
		let rowBytes = CGBitmapContextGetBytesPerRow(context)

		self.init(data: data, height: height, width: width, rowBytes: rowBytes)
	}
}

public extension CGImage {

	func imageByApplyingBlurWithRadius(blurRadius: CGFloat) throws -> CGImage {
		guard blurRadius > CGFloat(FLT_EPSILON) else { return self }

		return try CGImage.imageWithSize(self.size, flipped: false) { (effectOutContext, size) in
			try CGImage.imageWithSize(self.size, flipped: false) { (effectInContext, size) in
				let imageRect = CGRect(origin: CGPointZero, size: self.size)
				CGContextDrawImage(effectInContext, imageRect, self)

				var inBuffer = vImage_Buffer(context: effectInContext)
				var outBuffer = vImage_Buffer(context: effectOutContext)

				CGImage.vImageBoxConvolveOnSourceBuffer(&inBuffer, destinationBuffer: &outBuffer, radius: blurRadius)
			}
		}
	}

	func imageByApplyingBlurWithRadius_apple(blurRadius: CGFloat) throws -> CGImage {
		guard blurRadius > CGFloat(FLT_EPSILON) else { return self }

		return try CGImage.imageWithSize(self.size, flipped: false) { (context, size) in
			let imageRect = CGRect(origin: CGPointZero, size: self.size)
			let effectImage = try self.imageByApplyingBlurWithRadius(blurRadius)

			CGContextDrawImage(context, imageRect, self)
			CGContextDrawImage(context, imageRect, effectImage)
		}
	}

	private static func vImageBoxConvolveOnSourceBuffer(inout sourceBuffer: vImage_Buffer,
	                                                          inout destinationBuffer: vImage_Buffer,
	                                                                radius: CGFloat) {

		var radius = UInt32(floor(radius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
		if radius % 2 != 1 {
			radius += 1 // force radius to be odd so that the three box-blur methodology works.
		}

		let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)

		vImageBoxConvolve_ARGB8888(&sourceBuffer, &destinationBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
		vImageBoxConvolve_ARGB8888(&destinationBuffer, &sourceBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
		vImageBoxConvolve_ARGB8888(&sourceBuffer, &destinationBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
	}

}
