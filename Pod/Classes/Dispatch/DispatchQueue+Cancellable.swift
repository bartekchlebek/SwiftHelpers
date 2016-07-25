import Dispatch

private let syncQueue = DispatchQueue(label: "com.SwiftHelpers.Dispatch.CancellableSyncQueue", attributes: .serial)

public final class CancelationToken {
	private var cancelled = false
	private init() { }
	public func cancel() {
		syncQueue.sync {
			self.cancelled = true
		}
	}
}

public extension DispatchQueue {
	func cancellableAfter(_ seconds: Double, block: () -> Void) -> CancelationToken {
		let cancelationToken = CancelationToken()

		self.after(seconds) {

			var isCancelled = false
			syncQueue.sync {
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
