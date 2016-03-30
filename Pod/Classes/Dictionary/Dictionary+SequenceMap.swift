extension Dictionary {
    public init<T where T: SequenceType, T.Generator.Element == Value>
        (sequence: T, usingKeyForSequenceElement keyForSequenceElement: T.Generator.Element -> Key) {
        self = sequence.dictionaryWithKeyForItem(keyForSequenceElement)
    }
}

extension SequenceType {
    typealias Element = Generator.Element
    
    private func dictionaryWithKeyForItem<U: Hashable>
        (IDGetterForItem: (Generator.Element) -> U) -> [U: Generator.Element] {
        var dictionary = Dictionary<U, Element>(minimumCapacity: self.underestimateCount())
        for item in self {
            dictionary[IDGetterForItem(item)] = item
        }
        return dictionary
    }
}
