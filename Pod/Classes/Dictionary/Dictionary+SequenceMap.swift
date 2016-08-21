extension Dictionary {
	public init<T>(fromSequence sequence: T,
	            usingKeyForSequenceElement keyForSequenceElement: (T.Iterator.Element) -> Key)
		where T: Sequence, T.Iterator.Element == Value {

			var dictionary = Dictionary<Key, Value>(minimumCapacity: sequence.underestimatedCount)
			for item in sequence {
				dictionary[keyForSequenceElement(item)] = item
			}
			self = dictionary
	}
}
