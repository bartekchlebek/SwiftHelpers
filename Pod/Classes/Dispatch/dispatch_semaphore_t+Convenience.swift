import Dispatch

public extension dispatch_semaphore_t {
	func waitForever() {
		dispatch_semaphore_wait(self, DISPATCH_TIME_FOREVER)
	}

	func signal() {
		dispatch_semaphore_signal(self)
	}
}
