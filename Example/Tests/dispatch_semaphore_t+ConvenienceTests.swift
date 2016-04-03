import XCTest
import Nimble
import SwiftHelpers

private final class dispatch_semaphore_t_ConvenienceTests: XCTestCase {

	func testSemaphore() {
		let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
		let semaphore = dispatch_semaphore_create(0)

		var blockExecuted = false
		queue.dispatchAfter(0.1) { 
			blockExecuted = true
			semaphore.signal()
		}

		expect(blockExecuted) == false
		semaphore.waitForever()
		expect(blockExecuted) == true
	}

}
