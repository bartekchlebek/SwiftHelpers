import Dispatch

private let syncQueue = DispatchQueue(label: "com.SwiftHelpers.Dispatch.CancellableSyncQueue")

public final class CancelationToken {
	fileprivate var cancelled = false
	fileprivate init() { }
	public func cancel() {
		syncQueue.sync {
			self.cancelled = true
		}
	}
}

public extension DispatchQueue {
	func cancellableAfter(_ seconds: Double, block: @escaping () -> Void) -> CancelationToken {
		let cancelationToken = CancelationToken()

		self.asyncAfter(seconds) {

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
