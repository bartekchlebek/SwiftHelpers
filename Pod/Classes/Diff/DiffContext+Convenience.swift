public protocol Identifiable {
	associatedtype EquatableIDType: Equatable
	var ID: EquatableIDType { get }
}

public protocol FastIdentifiable: Identifiable {
	associatedtype HashableIDType: Hashable
	var ID: HashableIDType { get }
}

extension DiffContext {
	public init(oldItems: [T],
	            newItems: [T],
	            itemsContainItem: @escaping ([T], T) -> Bool,
	            indexOfItemInItems: @escaping (T, [T]) -> Int?,
	            isSameInstanceComparator: @escaping (T, T) -> Bool,
	            isEqualComparator: @escaping (T, T) -> Bool) {
		
		self.init(
			oldItems: oldItems,
			newItems: newItems,
			oldItemsContainItem: { itemsContainItem(oldItems, $0) },
			newItemsContainItem: { itemsContainItem(newItems, $0) },
			oldItemWithSameIDAsItem: { item in oldItems.findFirst { isSameInstanceComparator($0, item) } },
			newItemWithSameIDAsItem: { item in newItems.findFirst { isSameInstanceComparator($0, item) } },
			isSameInstanceComparator: isSameInstanceComparator,
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext {
	public init(oldItems: [T],
	            newItems: [T],
	            isSameInstanceComparator: @escaping (T, T) -> Bool,
	            isEqualComparator: @escaping (T, T) -> Bool) {
		
		self.init(
			oldItems: oldItems,
			newItems: newItems,
			oldItemsContainItem: { item in oldItems.contains { isSameInstanceComparator($0, item) } },
			newItemsContainItem: { item in newItems.contains { isSameInstanceComparator($0, item) } },
			oldItemWithSameIDAsItem: { item in oldItems.findFirst { isSameInstanceComparator($0, item) } },
			newItemWithSameIDAsItem: { item in newItems.findFirst { isSameInstanceComparator($0, item) } },
			isSameInstanceComparator: isSameInstanceComparator,
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext {
	public init<U: Equatable>(oldItems: [T],
	            newItems: [T],
	            instanceIdentifierGetter: @escaping (T) -> U,
	            isEqualComparator: @escaping (T, T) -> Bool) {
		
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
	            instanceIdentifierGetter: @escaping (T) -> U,
	            isEqualComparator: @escaping (T, T) -> Bool) {
		
		let oldItemsMap = Dictionary(fromSequence: oldItems, usingKeyForSequenceElement: instanceIdentifierGetter)
		let newItemsMap = Dictionary(fromSequence: newItems, usingKeyForSequenceElement: instanceIdentifierGetter)
		
		let haveSameID: (T, T) -> Bool = { instanceIdentifierGetter($0) == instanceIdentifierGetter($1) }
		
		self.init(
			oldItems: oldItems,
			newItems: newItems,
			oldItemsContainItem: { oldItemsMap[instanceIdentifierGetter($0)] != nil } ,
			newItemsContainItem: { newItemsMap[instanceIdentifierGetter($0)] != nil },
			oldItemWithSameIDAsItem: { oldItemsMap[instanceIdentifierGetter($0)] },
			newItemWithSameIDAsItem: { newItemsMap[instanceIdentifierGetter($0)] },
			isSameInstanceComparator: { haveSameID($0, $1) },
			isEqualComparator: isEqualComparator
		)
	}
}

extension DiffContext where T: Equatable {
	public init(oldItems: [T],
	            newItems: [T],
	            isSameInstanceComparator: @escaping (T, T) -> Bool) {
		
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
	            instanceIdentifierGetter: @escaping (T) -> U) {
		
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
	            isEqualComparator: @escaping (T, T) -> Bool) {
		
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
	            isEqualComparator: @escaping (T, T) -> Bool) {
		
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
