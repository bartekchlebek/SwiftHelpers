public struct ItemUpdateInfo<T> {
	public var from: T
	public var to: T
}

extension SequenceType {
	typealias Element = Generator.Element

	private func dictionaryWithKeyForItem<U: Hashable>(IDGetterForItem: (Element) -> U) -> [U: Element] {
		var dictionary = Dictionary<U, Element>(minimumCapacity: self.underestimateCount())
		for item in self {
			dictionary[IDGetterForItem(item)] = item
		}
		return dictionary
	}
}

public protocol Identifiable {
	associatedtype EquatableIDType: Equatable
	var ID: EquatableIDType { get }
}

public protocol FastIdentifiable: Identifiable {
	associatedtype HashableIDType: Hashable
	var ID: HashableIDType { get }
}

struct Row<T> {
	var lhs: T?
	var rhs: T?
}

public struct DiffContext<T> {
	public var oldItems: [T]
	public var newItems: [T]

	public var oldItemsContainItem: T -> Bool
	public var newItemsContainItem: T -> Bool

	public var oldItemsIndexOfItem: T -> Int?
	public var newItemsIndexOfItem: T -> Int?

	public var isSameInstanceComparator: (T, T) -> Bool
	public var isEqualComparator: (T, T) -> Bool

	public init(oldItems: [T],
	            newItems: [T],
	            oldItemsContainItem: T -> Bool,
	            newItemsContainItem: T -> Bool,
	            oldItemsIndexOfItem: T -> Int?,
	            newItemsIndexOfItem: T -> Int?,
	            isSameInstanceComparator: (T, T) -> Bool,
	            isEqualComparator: (T, T) -> Bool) {
		self.oldItems = oldItems
		self.newItems = newItems
		self.oldItemsContainItem = oldItemsContainItem
		self.newItemsContainItem = newItemsContainItem
		self.oldItemsIndexOfItem = oldItemsIndexOfItem
		self.newItemsIndexOfItem = newItemsIndexOfItem
		self.isSameInstanceComparator = isSameInstanceComparator
		self.isEqualComparator = isEqualComparator
	}
}

public struct IndexDiff {
	public var addedIndexes: [Int]
	public var removedIndexes: [Int]
	public var updatedIndexes: [Int]
	public var movedIndexes: [ItemUpdateInfo<Int>]

	public init<T>(_ context: DiffContext<T>) {
		let oldItems = context.oldItems
		let newItems = context.newItems
		let newItemsContainItem = context.newItemsContainItem
		let newItemsIndexOfItem = context.newItemsIndexOfItem
		let isSameInstanceComparator = context.isSameInstanceComparator
		let isEqualComparator = context.isEqualComparator

		var rows = Array<Row<T>>()

		var newIndex = 0
		var oldIndex = 0
		var rowIndex = 0

		var matchToOld = true
		var shouldSwitch = false

		while true {
			if newIndex >= newItems.count && oldIndex >= oldItems.count {
				break
			}
			rows.append(Row<T>(lhs: nil, rhs: nil))

			let oldItem: T? = (oldItems.count > oldIndex) ? oldItems[oldIndex] : nil
			let newItem: T? = (newItems.count > newIndex) ? newItems[newIndex] : nil

			if let oldItem = oldItem, newItem = newItem {
				let matchExistsOnBothSides = newItemsContainItem(oldItem)
				if matchExistsOnBothSides {
					if shouldSwitch {
						shouldSwitch = false
						matchToOld = !matchToOld
					}
					rows[rowIndex].lhs = oldItem
					rows[rowIndex].rhs = newItem
					newIndex += 1
					oldIndex += 1
				}
				else {
					shouldSwitch = true
					if matchToOld {
						rows[rowIndex].lhs = oldItem
						oldIndex += 1
					}
					else {
						rows[rowIndex].rhs = newItem
						newIndex += 1
					}
				}
			}
			else {
				if let oldItem = oldItem {
					rows[rowIndex].lhs = oldItem
					oldIndex += 1
				}
				else if let newItem = newItem {
					rows[rowIndex].rhs = newItem
					newIndex += 1
				}
			}

			rowIndex += 1
		}

		let newRowsWithoutNils = rows.filter { $0.rhs != nil }

		var movedIndexes: [ItemUpdateInfo<Int>] = []
		var addedIndexes: [Int] = []
		var removedIndexes: [Int] = []
		var updatedIndexes: [Int] = []

		var insertionShift = 0
		var removalShift = 0

		for (index, row) in rows.enumerate() {
			switch (row.lhs, row.rhs) {

			case (_?, nil):
				removalShift += 1
				removedIndexes.append(index - insertionShift)

			case (nil, _?):
				insertionShift += 1
				addedIndexes.append(index - removalShift)

			case (let lhs?, _?):
				guard let newIndex = newRowsWithoutNils.indexOf({ isSameInstanceComparator(lhs, $0.rhs!) }) else { continue }
				if (newIndex + removalShift - insertionShift) != index {
					movedIndexes.append(ItemUpdateInfo(from: index, to: newIndex))
				}

				guard let newItemIndex = newItemsIndexOfItem(lhs) else { continue }
				if !isEqualComparator(newItems[newItemIndex], lhs) {
					updatedIndexes.append(index)
				}

			case (nil, nil): break
			}
		}

		self.removedIndexes = removedIndexes
		self.addedIndexes = addedIndexes
		self.updatedIndexes = updatedIndexes
		self.movedIndexes = movedIndexes
	}
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
		let newItemsIndexOfItem = context.newItemsIndexOfItem

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
			if let index = newItemsIndexOfItem(item) where !isEqualComparator(item, newItems[index]) {
				let itemUpdateInfo = ItemUpdateInfo(from: item, to: newItems[index])
				updatedItems.append(itemUpdateInfo)
			}
		}

		self.removed = removedItems
		self.added = addedItems
		self.updated = updatedItems
	}
}

extension DiffContext {
	public init(oldItems: [T],
	            newItems: [T],
	            itemsContainItem: ([T], T) -> Bool,
	            indexOfItemInItems: (T, [T]) -> Int?,
	            isSameInstanceComparator: (T, T) -> Bool,
	            isEqualComparator: (T, T) -> Bool) {

		self.init(
			oldItems: oldItems,
			newItems: newItems,
			oldItemsContainItem: { itemsContainItem(oldItems, $0) },
			newItemsContainItem: { itemsContainItem(newItems, $0) },
			oldItemsIndexOfItem: { indexOfItemInItems($0, oldItems) },
			newItemsIndexOfItem: { indexOfItemInItems($0, newItems) },
			isSameInstanceComparator: isSameInstanceComparator,
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext {
	public init(oldItems: [T],
	            newItems: [T],
	            isSameInstanceComparator: (T, T) -> Bool,
	            isEqualComparator: (T, T) -> Bool) {

		self.init(
			oldItems: oldItems,
			newItems: newItems,
			oldItemsContainItem: { item in oldItems.contains { isSameInstanceComparator($0, item) } },
			newItemsContainItem: { item in newItems.contains { isSameInstanceComparator($0, item) } },
			oldItemsIndexOfItem: { item in oldItems.indexOf { isSameInstanceComparator($0, item) } },
			newItemsIndexOfItem: { item in newItems.indexOf { isSameInstanceComparator($0, item) } },
			isSameInstanceComparator: isSameInstanceComparator,
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext {
	public init<U: Equatable>(oldItems: [T],
	            newItems: [T],
	            instanceIdentifierGetter: T -> U,
	            isEqualComparator: (T, T) -> Bool) {

		self.init(oldItems: oldItems,
		          newItems: newItems,
		          isSameInstanceComparator: { instanceIdentifierGetter($0) == instanceIdentifierGetter($1) },
		          isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext {
	public init<U: Hashable>(oldItems: [T],
	            newItems: [T],
	            instanceIdentifierGetter: T -> U,
	            isEqualComparator: (T, T) -> Bool) {

		let oldItemsMap = oldItems.dictionaryWithKeyForItem(instanceIdentifierGetter)
		let newItemsMap = newItems.dictionaryWithKeyForItem(instanceIdentifierGetter)

		let haveSameID: (T, T) -> Bool = { instanceIdentifierGetter($0) == instanceIdentifierGetter($1) }

		self.init(
			oldItems: oldItems,
			newItems: newItems,
			oldItemsContainItem: { oldItemsMap[instanceIdentifierGetter($0)] != nil } ,
			newItemsContainItem: { newItemsMap[instanceIdentifierGetter($0)] != nil },
			oldItemsIndexOfItem: { item in oldItems.indexOf { haveSameID($0, item) } },
			newItemsIndexOfItem: { item in newItems.indexOf { haveSameID($0, item) } },
			isSameInstanceComparator: { haveSameID($0, $1) },
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext where T: Equatable {
	public init(oldItems: [T],
	            newItems: [T],
	            isSameInstanceComparator: (T, T) -> Bool) {

		self.init(oldItems: oldItems,
		          newItems: newItems,
		          isSameInstanceComparator: isSameInstanceComparator,
		          isEqualComparator: ==
		)
	}
}

extension DiffContext where T: Equatable {
	public init<U: Equatable>(oldItems: [T],
	            newItems: [T],
	            instanceIdentifierGetter: T -> U) {

		self.init(oldItems: oldItems,
		          newItems: newItems,
		          isSameInstanceComparator: { instanceIdentifierGetter($0) == instanceIdentifierGetter($1) },
		          isEqualComparator: ==
		)
	}
}

extension DiffContext where T: Identifiable {
	public init(oldItems: [T],
	            newItems: [T],
	            isEqualComparator: (T, T) -> Bool) {

		self.init(oldItems: oldItems,
		          newItems: newItems,
		          isSameInstanceComparator: { $0.ID == $1.ID },
		          isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext where T: Identifiable, T: Equatable {
	public init(oldItems: [T],
	            newItems: [T]) {

		self.init(oldItems: oldItems,
		          newItems: newItems,
		          isSameInstanceComparator: { $0.ID == $1.ID },
		          isEqualComparator: ==
		)
	}
}

extension DiffContext where T: FastIdentifiable {
	public init(oldItems: [T],
	            newItems: [T],
	            isEqualComparator: (T, T) -> Bool) {

		self.init(
			oldItems: oldItems,
			newItems: newItems,
			instanceIdentifierGetter: { $0.ID },
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext where T: FastIdentifiable, T: Equatable {
	public init(oldItems: [T],
	            newItems: [T]) {

		self.init(oldItems: oldItems,
		          newItems: newItems,
		          isEqualComparator: ==
		)
	}
}
