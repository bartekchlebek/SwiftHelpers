import Dispatch

public extension DispatchSemaphore {
	func waitForever() -> DispatchTimeoutResult {
		return self.wait(timeout: .distantFuture)
	}
}
