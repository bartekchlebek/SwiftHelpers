import XCTest
import Nimble
import SwiftHelpers

final class DispatchSemaphore_ConvenienceTests: XCTestCase {

	func testSemaphore() {
		let queue = DispatchQueue(label: "com.swifthelpers.test_queue")
		let semaphore = DispatchSemaphore(value: 0)

		var blockExecuted = false
		queue.asyncAfter(0.1) {
			blockExecuted = true
			semaphore.signal()
		}

		expect(blockExecuted) == false
		semaphore.waitForever()
		expect(blockExecuted) == true
	}

}
