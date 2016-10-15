import Dispatch

public extension DispatchQueue {
	func asyncAfter(_ seconds: Double, execute work: @escaping () -> Void) {
		self.asyncAfter(deadline: .now() + seconds, execute: work)
	}
}
