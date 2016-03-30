public struct ItemUpdateInfo<T> {
	public var from: T
	public var to: T
}

public struct Diff<T> {
	public var oldItems: [T]
	public var newItems: [T]
	
	public var added: [T]
	public var removed: [T]
	public var updated: [ItemUpdateInfo<T>]
	
	public init(_ context: DiffContext<T>) {
		self.oldItems = context.oldItems
		self.newItems = context.newItems
		
		let newItemsContainItem = context.newItemsContainItem
		let oldItemsContainItem = context.oldItemsContainItem
		let isEqualComparator = context.isEqualComparator
		let newItemWithSameIDAsItem = context.newItemWithSameIDAsItem
		
		var removedItems: [T] = []
		var addedItems: [T] = []
		var updatedItems: [ItemUpdateInfo<T>] = []
		
		for item in oldItems {
			if !newItemsContainItem(item) {
				removedItems.append(item)
			}
		}
		
		for item in newItems {
			if !oldItemsContainItem(item) {
				addedItems.append(item)
			}
		}
		
		for item in oldItems {
			if let newItem = newItemWithSameIDAsItem(item) where !isEqualComparator(item, newItem) {
				let itemUpdateInfo = ItemUpdateInfo(from: item, to: newItem)
				updatedItems.append(itemUpdateInfo)
			}
		}
		
		self.removed = removedItems
		self.added = addedItems
		self.updated = updatedItems
	}
}
