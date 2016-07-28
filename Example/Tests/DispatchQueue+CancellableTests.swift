import XCTest
import Nimble
import SwiftHelpers

final class DispatchQueue_CancellableTests: XCTestCase {

	func testWithoutCancelation() {
		var blockExecuted = false
		_ = DispatchQueue.global(attributes: .qosDefault).cancellableAfter(0.1) {
			blockExecuted = true
		}

		expect(blockExecuted).toEventually(beTruthy(), timeout: 2)
	}

	func testCancelation() {
		let cancelationToken = DispatchQueue.global(attributes: .qosDefault).cancellableAfter(0.1) {
			fail()
		}
		cancelationToken.cancel()
		usleep(200_000)
	}

}
