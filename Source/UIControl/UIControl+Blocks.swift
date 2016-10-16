#if os(iOS)
import UIKit
import ObjectiveC

private final class ProxyTarget {
	let handler: UIControl.Action
	let events: UIControlEvents

	init(handler: @escaping UIControl.Action, events: UIControlEvents) {
		self.handler = handler
		self.events = events
	}

	static let selector: Selector = #selector(ProxyTarget.handleActionFromSender(_:event:))
	@objc func handleActionFromSender(_ sender: UIControl, event: UIEvent) {
		self.handler(sender, event)
	}
}

private var proxyTargetsAssociatedObjectTag: UInt8 = 0

public extension UIControl {
	typealias Action = (_ sender: UIControl, _ event: UIEvent) -> Void

	struct ActionToken {
		fileprivate let key: String

		fileprivate init() {
			self.key = UUID().uuidString
		}
	}

	private var proxyTargets: [String: ProxyTarget] {
		get {
			if let proxyTargets = objc_getAssociatedObject(self, &proxyTargetsAssociatedObjectTag) as? [String: ProxyTarget] {
				return proxyTargets
			}
			let proxyTargets = [String: ProxyTarget]()
			self.proxyTargets = proxyTargets
			return proxyTargets
		}
		set {
			objc_setAssociatedObject(self, &proxyTargetsAssociatedObjectTag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	@discardableResult
	func addActionForControlEvents(_ controlEvents: UIControlEvents, action: @escaping Action) -> ActionToken {
		let token = ActionToken()
		let proxyTarget = ProxyTarget(handler: action, events: controlEvents)
		self.proxyTargets[token.key] = proxyTarget
		self.addTarget(proxyTarget, action: ProxyTarget.selector, for: controlEvents)

		return token
	}

	func removeActionWithToken(_ token: ActionToken) {
		guard let proxyHandler = self.proxyTargets[token.key] else { return }
		self.removeTarget(proxyHandler, action: ProxyTarget.selector, for: proxyHandler.events)
		self.proxyTargets[token.key] = nil
	}
}
#endif
