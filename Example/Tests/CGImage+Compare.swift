import Nimble
import Foundation
import ImageIO
import MobileCoreServices
import SwiftHelpers

//MARK:CGImage helpers

extension CGImage {
	func looksIdenticalTo(image: CGImage) -> Bool {
		return areRendersOfImagesEqual(self, image)
	}
}

private func areRendersOfImagesEqual(lhs: CGImage, _ rhs: CGImage) -> Bool {

	// Based on FBSnapshotTestCase's implementation. Props to those guys.
	// https://github.com/facebook/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/Categories/UIImage%2BCompare.m

	guard lhs.size == rhs.size else { return false }
	let minimumBytesPerRow = min(lhs.bytesPerRow, rhs.bytesPerRow)

	let imageSizeBytes = lhs.height * minimumBytesPerRow

	let lhsImagePixels = calloc(1, imageSizeBytes)
	let rhsImagePixels = calloc(1, imageSizeBytes)

	defer {
		free(lhsImagePixels)
		free(rhsImagePixels)
	}

	guard (lhsImagePixels != nil) && (rhsImagePixels != nil) else { return false }

	let bitmapContextForImage: (CGImage, buffer: UnsafeMutablePointer<Void>) -> CGContext? = { image, buffer in
		CGBitmapContextCreate(buffer,
		                      image.width,
		                      image.height,
		                      image.bitsPerComponent,
		                      minimumBytesPerRow,
		                      image.colorSpace,
		                      CGImageAlphaInfo.PremultipliedFirst.rawValue)
	}

	guard let
		lhsImageContext = bitmapContextForImage(lhs, buffer: lhsImagePixels),
		rhsImageContext = bitmapContextForImage(rhs, buffer: rhsImagePixels)
		else { return false }

	CGContextDrawImage(lhsImageContext, CGRectMake(0, 0, lhs.size.width, lhs.size.height), lhs)
	CGContextDrawImage(rhsImageContext, CGRectMake(0, 0, rhs.size.width, rhs.size.height), rhs)

	return memcmp(lhsImagePixels, rhsImagePixels, imageSizeBytes) == 0
}

private func CGImageCreateWithPNGDataProvider(source: CGDataProvider,
                                              decode: UnsafePointer<CGFloat> = nil,
                                              shouldInterpolate: Bool = false,
                                              intent: CGColorRenderingIntent = .RenderingIntentDefault) -> CGImage? {

	return CGImageCreateWithPNGDataProvider(source, decode, shouldInterpolate, intent)
}

private extension CGImage {
	func saveToPNGFileAtURL(URL: NSURL) -> Bool {
		guard let destination = CGImageDestinationCreateWithURL(URL, kUTTypePNG, 1, nil) else { return false }
		CGImageDestinationAddImage(destination, self, nil)
		return CGImageDestinationFinalize(destination)
	}
}

//MARK:Path helpers

private func referenceImagesDirectoryPathDerivedFromPath(path: String) -> String? {
	var pathComponents = path.pathComponents
	guard let directoryName = pathComponents.popLast()?.stringByDeletingPathExtension else { return nil }

	for (index, folder) in pathComponents.enumerate().reverse() {
		if folder.lowercaseString.containsString("tests") {
			var components = Array(pathComponents[0...index])
			components.appendContentsOf(["ReferenceImages", directoryName])
			return String(pathComponents: components)
		}
	}

	return nil
}

private func referenceImagePathWithName(name: String, derivedFromPath path: String) -> String? {
	let path = referenceImagesDirectoryPathDerivedFromPath(path)
	return path?.stringByAppendingPathComponent("\(name).png")
}

//MARK:Nimble extensions

func recordReferenceImageNamed(name: String, file: String = #file) -> MatcherFunc<CGImage> {
	return MatcherFunc { actualExpression, failureMessage in

		guard let
			referenceImagePath = referenceImagePathWithName(name, derivedFromPath: file),
			referenceImagesPath = referenceImagesDirectoryPathDerivedFromPath(file)
			else { return false }

		let fileManager = NSFileManager.defaultManager()
		try fileManager.createDirectoryAtPath(referenceImagesPath, withIntermediateDirectories: true, attributes: nil)

		let destinationURL = NSURL(fileURLWithPath: referenceImagePath)
		let image = try actualExpression.evaluate()
		image?.saveToPNGFileAtURL(destinationURL)
		return false
	}
}

func matchReferenceImageNamed(name: String, file: String = #file) -> MatcherFunc<CGImage> {
	return MatcherFunc { actualExpression, failureMessage in

		guard let
			referenceImagePath = referenceImagePathWithName(name, derivedFromPath: file),
			dataProvider = CGDataProviderCreateWithFilename(referenceImagePath),
			referenceImage = CGImageCreateWithPNGDataProvider(dataProvider),
			actualImage = try actualExpression.evaluate()
			else { return false }

		return areRendersOfImagesEqual(actualImage, referenceImage)
	}
}
