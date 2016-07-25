extension Dictionary {
	public init<T where T: Sequence, T.Iterator.Element == Value>(fromSequence sequence: T,
	            usingKeyForSequenceElement keyForSequenceElement: (T.Iterator.Element) -> Key) {
		
		var dictionary = Dictionary<Key, Value>(minimumCapacity: sequence.underestimatedCount)
		for item in sequence {
			dictionary[keyForSequenceElement(item)] = item
		}
		self = dictionary
	}
}
