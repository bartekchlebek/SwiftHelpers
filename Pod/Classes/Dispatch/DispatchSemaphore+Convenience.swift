import Dispatch

public extension DispatchSemaphore {
	func waitForever() {
		self.wait(timeout: DispatchTime.distantFuture)
	}
}
