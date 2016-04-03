import Dispatch

public extension dispatch_queue_t {
	func dispatchSync(block: () -> Void) {
		dispatch_sync(self, block)
	}

	func dispatchAsync(block: () -> Void) {
		dispatch_async(self, block)
	}

	func dispatchAfter(seconds: Double, block: () -> Void) {
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, self, block)
	}
}
