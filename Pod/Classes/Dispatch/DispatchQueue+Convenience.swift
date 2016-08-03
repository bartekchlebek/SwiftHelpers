import Dispatch

public extension DispatchQueue {
	func asyncAfter(_ seconds: Double, execute work: @convention(block) () -> Swift.Void) {
		self.asyncAfter(deadline: .now() + 1, execute: work)
	}
}
