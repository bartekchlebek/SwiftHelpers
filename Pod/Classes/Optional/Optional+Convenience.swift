public extension Optional {
	func iff(_ block: @noescape (Wrapped) -> Void) {
		switch self {
		case .some(let value): block(value)
		case .none: return
		}
	}
}
