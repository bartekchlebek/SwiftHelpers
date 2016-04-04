import XCTest
import Nimble
import SwiftHelpers

final class dispatch_queue_t_CancellableTests: XCTestCase {

	func testWithoutCancelation() {
		var blockExecuted = false
		let queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
		queue.cancellableDispatchAfter(0.1) {
			blockExecuted = true
		}
		expect(blockExecuted).toEventually(beTruthy())
	}

	func testCancelation() {
		let queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
		let cancelationToken = queue.cancellableDispatchAfter(0.1) {
			fail()
		}
		cancelationToken.cancel()
		usleep(200_000)
	}

}
