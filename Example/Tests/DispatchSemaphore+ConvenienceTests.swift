import XCTest
import Nimble
import SwiftHelpers

final class DispatchSemaphore_ConvenienceTests: XCTestCase {

	func testSemaphore() {
		let queue = DispatchQueue(label: "com.swifthelpers.test_queue", attributes: .serial)
		let semaphore = DispatchSemaphore(value: 0)

		var blockExecuted = false
		queue.after(0.1) {
			blockExecuted = true
			semaphore.signal()
		}

		expect(blockExecuted) == false
		semaphore.waitForever()
		expect(blockExecuted) == true
	}

}
