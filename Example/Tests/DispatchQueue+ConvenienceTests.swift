import XCTest
import Nimble
import SwiftHelpers

final class DispatchQueue_ConvenienceTests: XCTestCase {

	func testDispatchAfter() {
		let queue = DispatchQueue.main
		var blockExecuted = false
		queue.after(0.3) {
			blockExecuted = true
		}
		expect(blockExecuted) == false
		expect(blockExecuted).toEventually(beTruthy())
	}
	
}
