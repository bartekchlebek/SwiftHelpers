import XCTest
import Nimble
import SwiftHelpers

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

}
