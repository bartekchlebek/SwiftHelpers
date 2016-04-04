import UIKit
import ObjectiveC

private final class ProxyTarget {
	let handler: UIControl.Action
	let events: UIControlEvents

	init(handler: UIControl.Action, events: UIControlEvents) {
		self.handler = handler
		self.events = events
	}

	static let selector: Selector = #selector(ProxyTarget.handleActionFromSender(_:event:))
	@objc func handleActionFromSender(sender: UIControl, event: UIEvent) {
		self.handler(sender: sender, event: event)
	}
}

private var proxyTargetsAssociatedObjectTag: UInt8 = 0

public extension UIControl {
	typealias Action = (sender: UIControl, event: UIEvent) -> Void

	final class ActionToken {
		private let key: String
		private let onDeinit: ActionToken -> Void

		private init(onDeinit: ActionToken -> Void) {
			self.key = NSUUID().UUIDString
			self.onDeinit = onDeinit
		}

		deinit {
			self.onDeinit(self)
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

	@warn_unused_result
	func addActionForControlEvents(controlEvents: UIControlEvents, action: Action) -> ActionToken {

		let token = ActionToken(onDeinit: { [weak self] in self?.removeActionWithToken($0) })

		let proxyTarget = ProxyTarget(handler: action, events: controlEvents)
		self.proxyTargets[token.key] = proxyTarget
		self.addTarget(proxyTarget, action: ProxyTarget.selector, forControlEvents: controlEvents)

		return token
	}

	func removeActionWithToken(token: ActionToken) {
		guard let proxyHandler = self.proxyTargets[token.key] else { return }
		self.removeTarget(proxyHandler, action: ProxyTarget.selector, forControlEvents: proxyHandler.events)
		self.proxyTargets[token.key] = nil
	}
}

public extension UIControl {
	func addActionForControlEvents<T: AnyObject>(controlEvents: UIControlEvents, removedOnDeinitOf object: T,
	                               action: (sender: UIControl, event: UIEvent, boundObject: T) -> Void) -> ActionToken {

		let token = self.addActionForControlEvents(controlEvents) { [weak object] (sender, event) in
			guard let boundObject = object else { return }
			action(sender: sender, event: event, boundObject: boundObject)
		}

		onDeinitOfObject(object) { [weak self] in self?.removeActionWithToken(token) }

		return token
	}
}
