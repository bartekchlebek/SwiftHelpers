import XCTest
import Nimble
import SwiftHelpers

class dispatch_queue_t_ConvenienceTests: XCTestCase {

	func testDispatchSync() {
		let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
		var blockExecuted = false
		queue.dispatchSync { 
			blockExecuted = true
		}
		expect(blockExecuted) == true
	}

	func testDispatchAsync() {
		let queue = dispatch_get_main_queue()
		var blockExecuted = false
		queue.dispatchAsync {
			blockExecuted = true
		}
		expect(blockExecuted) == false
		expect(blockExecuted).toEventually(beTruthy())
	}

	func testDispatchAfter() {
		let queue = dispatch_get_main_queue()
		var blockExecuted = false
		queue.cancellableDispatchAfter(0.3) {
			blockExecuted = true
		}
		expect(blockExecuted) == false
		expect(blockExecuted).toEventually(beTruthy())
	}

}
