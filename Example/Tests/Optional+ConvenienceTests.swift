import XCTest
import Nimble
import SwiftHelpers

private enum Error: ErrorType {
	case MockError
}

final class Optional_ConvenienceTests: XCTestCase {

	func testNone() {
		var blockCalled = false
		let optional: Optional<String> = nil
		optional.iff { _ in
			blockCalled = true
		}
		expect(blockCalled) == false
	}

	func testSome() {
		var blockCalled = false
		let optional: Optional<String> = "string"
		optional.iff {
			expect($0) == "string"
			blockCalled = true
		}
		expect(blockCalled) == true
	}

	func testRethrow() {
		var errorCaught = false
		let optional: Optional<Void> = Void()

		do {
			try optional.iff {
				throw Error.MockError
			}
		}
		catch {
			errorCaught = true
		}

		expect(errorCaught) == true
	}

}
