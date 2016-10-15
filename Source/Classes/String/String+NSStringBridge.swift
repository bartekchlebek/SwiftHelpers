import Foundation

public extension String {
	init(pathComponents: [String]) {
		self = NSString.path(withComponents: pathComponents)
	}

	var stringByDeletingPathExtension: String {
		return (self as NSString).deletingPathExtension
	}

	var pathComponents: [String] {
		return (self as NSString).pathComponents
	}

	func stringByAppendingPathComponent(_ pathComponent: String) -> String {
		return (self as NSString).appendingPathComponent(pathComponent)
	}
}
