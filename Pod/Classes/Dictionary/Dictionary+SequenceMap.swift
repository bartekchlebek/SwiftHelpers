extension Dictionary {
	public init<T where T: SequenceType, T.Generator.Element == Value>(fromSequence sequence: T,
	            usingKeyForSequenceElement keyForSequenceElement: T.Generator.Element -> Key) {
		
		var dictionary = Dictionary<Key, Value>(minimumCapacity: sequence.underestimateCount())
		for item in sequence {
			dictionary[keyForSequenceElement(item)] = item
		}
		self = dictionary
	}
}
