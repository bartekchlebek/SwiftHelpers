public extension Optional {
	func iff(@noescape block: (Wrapped) throws -> Void) rethrows {
		switch self {
		case .Some(let value): try block(value)
		case .None: return
		}
	}
}
