extension Sequence {
	public func findFirst(_ evaluate: (Iterator.Element) -> Bool) -> Iterator.Element? {
		for element in self {
			if evaluate(element) {
				return element
			}
		}
		return nil
	}
}
