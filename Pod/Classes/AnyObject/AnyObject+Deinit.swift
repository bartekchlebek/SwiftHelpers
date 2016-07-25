import ObjectiveC

private var associatedObjectTag: UInt8 = 0

private final class DeinitBlockWrapper {
	let block: () -> Void

	init(block: () -> Void) {
		self.block = block
	}

	deinit {
		self.block()
	}
}

func onDeinit<T: AnyObject>(of object: T, performAction action: () -> Void) {
	let getDeinitActions = {
		return objc_getAssociatedObject(object, &associatedObjectTag) as? NSMutableArray
	}

	let createAndSetDeinitActions: () -> NSMutableArray = {
		let observers = NSMutableArray()
		objc_setAssociatedObject(object, &associatedObjectTag, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return observers
	}

	let deinitActions = getDeinitActions() ?? createAndSetDeinitActions()
	deinitActions.add(DeinitBlockWrapper(block: action))
}
