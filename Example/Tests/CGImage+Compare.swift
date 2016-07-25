import Nimble
import Foundation
import ImageIO
import MobileCoreServices
import SwiftHelpers

//MARK:CGImage helpers

private func areRendersOfImagesEqual(_ lhs: CGImage, _ rhs: CGImage) -> Bool {

	// Based on FBSnapshotTestCase's implementation. Props to those guys.
	// https://github.com/facebook/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/Categories/UIImage%2BCompare.m

	guard lhs.size == rhs.size else { return false }
	let minimumBytesPerRow = min(lhs.bytesPerRow, rhs.bytesPerRow)

	let imageSizeBytes = lhs.height * minimumBytesPerRow

	let lhsImagePixels = calloc(1, imageSizeBytes)!
	let rhsImagePixels = calloc(1, imageSizeBytes)!

	defer {
		free(lhsImagePixels)
		free(rhsImagePixels)
	}

	let bitmapContextForImage: (CGImage, buffer: UnsafeMutablePointer<Void>) -> CGContext? = { image, buffer in
		CGContext(data: buffer,
		          width: image.width,
		          height: image.height,
		          bitsPerComponent: image.bitsPerComponent,
		          bytesPerRow: minimumBytesPerRow,
		          space: image.colorSpace!,
		          bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
	}

	guard let
		lhsImageContext = bitmapContextForImage(lhs, buffer: lhsImagePixels),
		let rhsImageContext = bitmapContextForImage(rhs, buffer: rhsImagePixels)
		else { return false }

	lhsImageContext.draw(in: CGRect(x: 0, y: 0, width: lhs.size.width, height: lhs.size.height), image: lhs)
	rhsImageContext.draw(in: CGRect(x: 0, y: 0, width: rhs.size.width, height: rhs.size.height), image: rhs)

	return memcmp(lhsImagePixels, rhsImagePixels, imageSizeBytes) == 0
}

private func CGImageCreateWithPNGDataProvider(_ source: CGDataProvider,
                                              decode: UnsafePointer<CGFloat>? = nil,
                                              shouldInterpolate: Bool = false,
                                              intent: CGColorRenderingIntent = .defaultIntent) -> CGImage? {

	return CGImage(pngDataProviderSource: source, decode: decode, shouldInterpolate: shouldInterpolate, intent: intent)
}

private extension CGImage {
	func saveToPNGFileAtURL(_ URL: Foundation.URL) -> Bool {
		guard let destination = CGImageDestinationCreateWithURL(URL, kUTTypePNG, 1, nil) else { return false }
		CGImageDestinationAddImage(destination, self, nil)
		return CGImageDestinationFinalize(destination)
	}
}

//MARK:Path helpers

private func referenceImagesDirectoryPathDerivedFromPath(_ path: String) -> String? {
	var pathComponents = path.pathComponents
	guard let directoryName = pathComponents.popLast()?.stringByDeletingPathExtension else { return nil }

	for (index, folder) in pathComponents.enumerated().reversed() {
		if folder.lowercased().contains("tests") {
			var components = Array(pathComponents[0...index])
			components.append(contentsOf: ["ReferenceImages", directoryName])
			return String(pathComponents: components)
		}
	}

	return nil
}

private func referenceImagePathWithName(_ name: String, derivedFromPath path: String) -> String? {
	let path = referenceImagesDirectoryPathDerivedFromPath(path)
	return path?.stringByAppendingPathComponent("\(name).png")
}

//MARK:Nimble extensions

func recordReferenceImageNamed(_ name: String, file: String = #file) -> MatcherFunc<CGImage> {
	return MatcherFunc { actualExpression, failureMessage in

		guard let
			referenceImagePath = referenceImagePathWithName(name, derivedFromPath: file),
			let referenceImagesPath = referenceImagesDirectoryPathDerivedFromPath(file)
			else { return false }

		let fileManager = FileManager.default
		try fileManager.createDirectory(atPath: referenceImagesPath, withIntermediateDirectories: true, attributes: nil)

		let destinationURL = URL(fileURLWithPath: referenceImagePath)
		let image = try actualExpression.evaluate()
		_ = image?.saveToPNGFileAtURL(destinationURL)
		return false
	}
}

func matchReferenceImageNamed(_ name: String, file: String = #file) -> MatcherFunc<CGImage> {
	return MatcherFunc { actualExpression, failureMessage in

		guard let
			referenceImagePath = referenceImagePathWithName(name, derivedFromPath: file),
			let dataProvider = CGDataProvider(filename: referenceImagePath),
			let referenceImage = CGImageCreateWithPNGDataProvider(dataProvider),
			let actualImage = try actualExpression.evaluate()
			else { return false }

		return areRendersOfImagesEqual(actualImage, referenceImage)
	}
}
