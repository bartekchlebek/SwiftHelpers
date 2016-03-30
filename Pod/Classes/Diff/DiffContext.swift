public struct DiffContext<T> {
	public var oldItems: [T]
	public var newItems: [T]
	
	public var oldItemsContainItem: T -> Bool
	public var newItemsContainItem: T -> Bool
	
	public var oldItemWithSameIDAsItem: T -> T?
	public var newItemWithSameIDAsItem: T -> T?
	
	public var isSameInstanceComparator: (T, T) -> Bool
	public var isEqualComparator: (T, T) -> Bool
	
	public init(oldItems: [T],
	            newItems: [T],
	            oldItemsContainItem: T -> Bool,
	            newItemsContainItem: T -> Bool,
	            oldItemWithSameIDAsItem: T -> T?,
	            newItemWithSameIDAsItem: T -> T?,
	            isSameInstanceComparator: (T, T) -> Bool,
	            isEqualComparator: (T, T) -> Bool) {
		self.oldItems = oldItems
		self.newItems = newItems
		self.oldItemsContainItem = oldItemsContainItem
		self.newItemsContainItem = newItemsContainItem
		self.oldItemWithSameIDAsItem = oldItemWithSameIDAsItem
		self.newItemWithSameIDAsItem = newItemWithSameIDAsItem
		self.isSameInstanceComparator = isSameInstanceComparator
		self.isEqualComparator = isEqualComparator
	}
}
