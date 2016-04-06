public extension Optional {
	func iff(@noescape block: Wrapped -> Void) {
		switch self {
		case .Some(let value): block(value)
		case .None: return
		}
	}
}
