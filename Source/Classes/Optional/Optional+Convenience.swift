public extension Optional {
	func iff(_ block: (Wrapped) -> Void) {
		switch self {
		case .some(let value): block(value)
		case .none: return
		}
	}
}

public extension Optional {
	func unwrapped(throwing error: @autoclosure () -> Error = genericError) throws -> Wrapped {
		guard let value = self else { throw error() }
		return value
	}
}
