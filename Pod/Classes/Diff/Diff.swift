public struct Diff<T> {
	public var oldItems: [T]
	public var newItems: [T]
	
	public var added: [T]
	public var removed: [T]
	public var updated: [ChangeDescriptor<T>]
	
	public init(_ context: DiffContext<T>) {
		self.oldItems = context.oldItems
		self.newItems = context.newItems
		
		let newItemsContainItem = context.newItemsContainItem
		let oldItemsContainItem = context.oldItemsContainItem
		let isEqualComparator = context.isEqualComparator
		let newItemWithSameIDAsItem = context.newItemWithSameIDAsItem
		
		var removedItems: [T] = []
		var addedItems: [T] = []
		var updatedItems: [ChangeDescriptor<T>] = []
		
		for oldItem in oldItems {
			if !newItemsContainItem(oldItem) {
				removedItems.append(oldItem)
			}
		}
		
		for newItem in newItems {
			if !oldItemsContainItem(newItem) {
				addedItems.append(newItem)
			}
		}
		
		for oldItem in oldItems {
			if let newItem = newItemWithSameIDAsItem(oldItem) where !isEqualComparator(oldItem, newItem) {
				let itemUpdateInfo = ChangeDescriptor(from: oldItem, to: newItem)
				updatedItems.append(itemUpdateInfo)
			}
		}
		
		self.removed = removedItems
		self.added = addedItems
		self.updated = updatedItems
	}
}
