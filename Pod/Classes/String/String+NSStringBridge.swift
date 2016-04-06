import Foundation

public extension String {
	init(pathComponents: [String]) {
		self = NSString.pathWithComponents(pathComponents)
	}

	var stringByDeletingPathExtension: String {
		return (self as NSString).stringByDeletingPathExtension
	}

	var pathComponents: [String] {
		return (self as NSString).pathComponents
	}

	func stringByAppendingPathComponent(pathComponent: String) -> String {
		return (self as NSString).stringByAppendingPathComponent(pathComponent)
	}
}
