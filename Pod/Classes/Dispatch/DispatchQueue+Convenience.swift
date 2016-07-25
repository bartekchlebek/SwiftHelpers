import Dispatch

public extension DispatchQueue {
	func after(_ seconds: Double, execute work: @convention(block) () -> Swift.Void) {
		self.after(when: .now() + 1, execute: work)
	}
}
