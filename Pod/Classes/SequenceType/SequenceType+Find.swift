extension SequenceType {
    public func findFirst(evaluate: Generator.Element -> Bool) -> Generator.Element? {
        for element in self {
            if evaluate(element) {
                return element
            }
        }
        return nil
    }
}
