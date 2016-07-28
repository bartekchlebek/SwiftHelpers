import XCTest
import Nimble
import SwiftHelpers

private enum CustomError: ErrorProtocol {
	case error
}

final class Optional_ConvenienceTests: XCTestCase {

	func testExample() {
		var blockCalled = false
		let optional: Optional<String> = "string"
		optional.iff {
			expect($0) == "string"
			blockCalled = true
		}
		expect(blockCalled) == true
	}

	func testUnwrapped() {

		let noneOptional: Optional<String> = .none
		do {
			_ = try noneOptional.unwrapped()
			fail("try optional.unwrapped() should throw")
		}
		catch {

		}

		do {
			_ = try noneOptional.unwrapped(throwing: CustomError.error)
			fail("try optional.unwrapped() should throw")
		}
		catch {
			expect(error is CustomError).to(beTruthy())
		}

		let someOptional: Optional<String> = "String"
		do {
			let value = try someOptional.unwrapped()
			expect(value) == "String"
		}
		catch {
			fail("try optional.unwrapped() should not throw")
		}
	}

}
