import XCTest
import Nimble
import SwiftHelpers

final class String_NSStringBridge: XCTestCase {

	func testNSStringPathWithComponents() {
		let components = ["/", "User", "Files", "file.png"]
		let a = NSString.path(withComponents: components)
		let b = String(pathComponents: components)
		expect(a) == b
	}

	func testStringByDeletingPathExtension() {
		let fileWithExtension = "file.png"
		let a = NSString(string: fileWithExtension).deletingPathExtension
		let b = fileWithExtension.stringByDeletingPathExtension
		expect(a) == b
	}

	func testPathComponents() {
		let path = "/User/Files/file.png"
		let a = NSString(string: path).pathComponents
		let b = path.pathComponents
		expect(a) == b
	}

	func testStringByAppendingPathComponent() {
		let path = "/User/Files"
		let a = NSString(string: path).appendingPathComponent("file.png")
		let b = path.stringByAppendingPathComponent("file.png")
		expect(a) == b
	}
	
}
