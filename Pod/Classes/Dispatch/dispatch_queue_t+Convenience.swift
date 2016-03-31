import Dispatch

extension dispatch_queue_t {
	public func dispatchSync(block: () -> Void) {
		dispatch_sync(self, block)
	}

	public func dispatchAsync(block: () -> Void) {
		dispatch_async(self, block)
	}

	public func dispatchAfter(seconds: Double, block: () -> Void) {
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, self, block)
	}
}
