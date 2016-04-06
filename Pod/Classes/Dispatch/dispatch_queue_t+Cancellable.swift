import Dispatch

private let syncQueue = dispatch_queue_create("com.SwiftHelpers.Dispatch.CancellableSyncQueue", DISPATCH_QUEUE_SERIAL)

public final class CancelationToken {
	private var cancelled = false
	private init() { }
	public func cancel() {
		syncQueue.dispatchSync {
			self.cancelled = true
		}
	}
}

public extension dispatch_queue_t {
	func cancellableDispatchAfter(seconds: Double, block: () -> Void) -> CancelationToken {
		let cancelationToken = CancelationToken()

		self.dispatchAfter(seconds) {

			var isCancelled = false
			syncQueue.dispatchSync {
				isCancelled = cancelationToken.cancelled
			}

			if isCancelled {
				return
			}

			block()
		}
		return cancelationToken
	}
}
