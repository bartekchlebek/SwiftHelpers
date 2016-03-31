import Dispatch

extension dispatch_semaphore_t {
	public func waitForever() {
		dispatch_semaphore_wait(self, DISPATCH_TIME_FOREVER)
	}

	public func signal() {
		dispatch_semaphore_signal(self)
	}
}
