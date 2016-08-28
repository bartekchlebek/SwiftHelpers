import XCTest
import Nimble
import SwiftHelpers

struct DiffedItem {
	var ID: String
	var property: String
}

struct EquatableDiffedItem: Equatable {
	var ID: String
	var property: String
}

struct IdentifiableDiffedItem: Identifiable {
	var ID: String
	var property: String
}

struct FastIdentifiableDiffedItem: FastIdentifiable {
	var ID: String
	var property: String
}

struct IdentifiableEquatableDiffedItem: Identifiable, Equatable {
	var ID: String
	var property: String
}

struct FastIdentifiableEquatableDiffedItem: FastIdentifiable, Equatable {
	var ID: String
	var property: String
}

func ==(lhs: EquatableDiffedItem, rhs: EquatableDiffedItem) -> Bool {
	return (lhs.ID == rhs.ID) && (lhs.property == rhs.property)
}

func ==(lhs: IdentifiableEquatableDiffedItem, rhs: IdentifiableEquatableDiffedItem) -> Bool {
	return (lhs.ID == rhs.ID) && (lhs.property == rhs.property)
}

func ==(lhs: FastIdentifiableEquatableDiffedItem, rhs: FastIdentifiableEquatableDiffedItem) -> Bool {
	return (lhs.ID == rhs.ID) && (lhs.property == rhs.property)
}

struct TestScenario<T> {
	var oldItems: [T]
	var newItems: [T]
	var added: [T]
	var removed: [T]
	var updatedFrom: [T]
	var updatedTo: [T]
	var addedIndexes: [Int]
	var removedIndexes: [Int]
	var updatedIndexes: [Int]
	var movedFromIndexes: [Int]
	var movedToIndexes: [Int]

	init(oldItems: [T],
	     newItems: [T],
	     added: [T],
	     removed: [T],
	     updatedFrom: [T],
	     updatedTo: [T],
	     addedIndexes: [Int],
	     removedIndexes: [Int],
	     updatedIndexes: [Int],
	     movedFromIndexes: [Int],
	     movedToIndexes: [Int]) {
		self.oldItems = oldItems
		self.newItems = newItems
		self.added = added
		self.removed = removed
		self.updatedFrom = updatedFrom
		self.updatedTo = updatedTo
		self.addedIndexes = addedIndexes
		self.removedIndexes = removedIndexes
		self.updatedIndexes = updatedIndexes
		self.movedFromIndexes = movedFromIndexes
		self.movedToIndexes = movedToIndexes
	}

	init<U>(fromScenario scenario: TestScenario<U>, conversionBlock: (U) -> T) {
		self.oldItems = scenario.oldItems.map(conversionBlock)
		self.newItems = scenario.newItems.map(conversionBlock)
		self.added = scenario.added.map(conversionBlock)
		self.removed = scenario.removed.map(conversionBlock)
		self.updatedFrom = scenario.updatedFrom.map(conversionBlock)
		self.updatedTo = scenario.updatedTo.map(conversionBlock)
		self.addedIndexes = scenario.addedIndexes
		self.removedIndexes = scenario.removedIndexes
		self.updatedIndexes = scenario.updatedIndexes
		self.movedFromIndexes = scenario.movedFromIndexes
		self.movedToIndexes = scenario.movedToIndexes
	}
}

let testScenarioSource = TestScenario(
	oldItems: [
		(ID: "1", property: "a"), // stays
		(ID: "2", property: "b"), // stays
		(ID: "3", property: "c"), // is removed
		(ID: "4", property: "d"), // is removed
		(ID: "5", property: "e"), // is updated
		(ID: "6", property: "f"), // is updated
		(ID: "7", property: "g"), // is moved
		(ID: "8", property: "h"), // is moved
		//			(ID: "9", property: "i"), // is added
		//			(ID: "10", property: "j"), // is added
	],
	newItems: [
		(ID: "1", property: "a"), // stays
		(ID: "2", property: "b"), // stays
		//			(ID: "3", property: "c"), // is removed
		//			(ID: "4", property: "d"), // is removed
		(ID: "5", property: "E"), // is updated
		(ID: "6", property: "F"), // is updated
		(ID: "8", property: "h"), // is moved
		(ID: "7", property: "g"), // is moved
		(ID: "9", property: "i"), // is added
		(ID: "10", property: "j"), // is added
	],
	added: [
		(ID: "9", property: "i"),
		(ID: "10", property: "j"),
		],
	removed: [
		(ID: "3", property: "c"),
		(ID: "4", property: "d"),
		],
	updatedFrom: [
		(ID: "5", property: "e"),
		(ID: "6", property: "f"),
		],
	updatedTo: [
		(ID: "5", property: "E"),
		(ID: "6", property: "F"),
		],
	addedIndexes: [6, 7],
	removedIndexes: [2, 3],
	updatedIndexes: [4, 5],
	movedFromIndexes: [6, 7],
	movedToIndexes: [5, 4]
)

let testScenario = TestScenario(fromScenario: testScenarioSource) {
	DiffedItem(ID: $0.ID, property: $0.property)
}

let equatableTestScenario = TestScenario(fromScenario: testScenarioSource) {
	EquatableDiffedItem(ID: $0.ID, property: $0.property)
}

let identifiableTestScenario = TestScenario(fromScenario: testScenarioSource) {
	IdentifiableDiffedItem(ID: $0.ID, property: $0.property)
}

let fastIdentifiableTestScenario = TestScenario(fromScenario: testScenarioSource) {
	FastIdentifiableDiffedItem(ID: $0.ID, property: $0.property)
}

let identifiableEquatableTestScenario = TestScenario(fromScenario: testScenarioSource) {
	IdentifiableEquatableDiffedItem(ID: $0.ID, property: $0.property)
}

let fastIdentifiableEquatableTestScenario = TestScenario(fromScenario: testScenarioSource) {
	FastIdentifiableEquatableDiffedItem(ID: $0.ID, property: $0.property)
}

final class DiffTests: XCTestCase {

	func performTestWithContext<T>(_ context: DiffContext<T>,
	                            testScenario: TestScenario<T>,
	                            elementComparison: @escaping (T, T) -> Bool) {
		let diff = Diff(context)
		print(diff.added)
		print(testScenario.added)
		expect(diff.added.elementsEqual(testScenario.added, by: elementComparison)).to(beTrue())
		expect(diff.added.elementsEqual(testScenario.added, by: elementComparison)) == true
		expect(diff.removed.elementsEqual(testScenario.removed, by: elementComparison)) == true
		expect(diff.updated.map{ $0.from }.elementsEqual(testScenario.updatedFrom, by: elementComparison)) == true
		expect(diff.updated.map{ $0.to }.elementsEqual(testScenario.updatedTo, by: elementComparison)) == true

		let indexDiff = IndexDiff(context)
		expect(indexDiff.addedIndexes) == testScenario.addedIndexes
		expect(indexDiff.removedIndexes) == testScenario.removedIndexes
		expect(indexDiff.updatedIndexes) == testScenario.updatedIndexes
		expect(indexDiff.movedIndexes.map({ $0.from })) == testScenario.movedFromIndexes
		expect(indexDiff.movedIndexes.map({ $0.to })) == testScenario.movedToIndexes
	}

	func performTestWithContext<T: Equatable>(_ context: DiffContext<T>, testScenario: TestScenario<T>) {
		self.performTestWithContext(context, testScenario: testScenario, elementComparison: ==)
	}

	func testDiffWithVerboseDiffContext() {
		let context = DiffContext<DiffedItem>(
			oldItems: testScenario.oldItems,
			newItems: testScenario.newItems,
			oldItemsContainItem: { item in testScenario.oldItems.contains { $0.ID == item.ID} },
			newItemsContainItem: { item in testScenario.newItems.contains { $0.ID == item.ID} },
			oldItemWithSameIDAsItem: { item in
				testScenario.oldItems.index { $0.ID == item.ID }.map { testScenario.oldItems[$0] }
			},
			newItemWithSameIDAsItem: { item in
				testScenario.newItems.index { $0.ID == item.ID }.map { testScenario.newItems[$0] }
			},
			isSameInstanceComparator: { $0.ID == $1.ID },
			isEqualComparator: { ($0.ID == $1.ID) && ($0.property == $1.property) }
		)
		self.performTestWithContext(context, testScenario: testScenario) {
			($0.ID == $1.ID) && ($0.property == $1.property)
		}
	}

	func testDiffWithConciseDiffContext1() {
		let context = DiffContext<DiffedItem>(
			oldItems: testScenario.oldItems,
			newItems: testScenario.newItems,
			isSameInstanceComparator: { $0.ID == $1.ID },
			isEqualComparator: { ($0.ID == $1.ID) && ($0.property == $1.property) }
		)
		self.performTestWithContext(context, testScenario: testScenario) {
			($0.ID == $1.ID) && ($0.property == $1.property)
		}
	}

	func testDiffWithConciseDiffContext2() {
		let context = DiffContext<DiffedItem>(
			oldItems: testScenario.oldItems,
			newItems: testScenario.newItems,
			itemsContainItem: { (items, item) -> Bool in return items.contains { $0.ID == item.ID } },
			indexOfItemInItems: { (item, items) -> Int? in return items.index { $0.ID == item.ID } },
			isSameInstanceComparator: { $0.ID == $1.ID },
			isEqualComparator: { ($0.ID == $1.ID) && ($0.property == $1.property) }
		)
		self.performTestWithContext(context, testScenario: testScenario) {
			($0.ID == $1.ID) && ($0.property == $1.property)
		}
	}

	func testDiffWithConciseDiffContext3() {
		let context = DiffContext<DiffedItem>(
			oldItems: testScenario.oldItems,
			newItems: testScenario.newItems,
			instanceIdentifierGetter: { $0.ID },
			isEqualComparator: { ($0.ID == $1.ID) && ($0.property == $1.property) }
		)
		self.performTestWithContext(context, testScenario: testScenario) {
			($0.ID == $1.ID) && ($0.property == $1.property)
		}
	}

	func testDiffWithDiffContextOfEquatableType() {
		let context = DiffContext<EquatableDiffedItem>(
			oldItems: equatableTestScenario.oldItems,
			newItems: equatableTestScenario.newItems,
			isSameInstanceComparator: { $0.ID == $1.ID }
		)
		self.performTestWithContext(context, testScenario: equatableTestScenario)
	}

	func testDiffWithDiffContextOfIdentifiableType() {
		let context = DiffContext<IdentifiableDiffedItem>(
			oldItems: identifiableTestScenario.oldItems,
			newItems: identifiableTestScenario.newItems,
			isEqualComparator: { ($0.ID == $1.ID) && ($0.property == $1.property) }
		)
		self.performTestWithContext(context, testScenario: identifiableTestScenario) {
			($0.ID == $1.ID) && ($0.property == $1.property)
		}
	}

	func testDiffWithDiffContextOfIdentifiableAndEquatableType() {
		let context = DiffContext<IdentifiableEquatableDiffedItem>(
			oldItems: identifiableEquatableTestScenario.oldItems,
			newItems: identifiableEquatableTestScenario.newItems
		)
		self.performTestWithContext(context, testScenario: identifiableEquatableTestScenario)
	}

	func testDiffWithDiffContextOfFastIdentifiableType() {
		let context = DiffContext<FastIdentifiableDiffedItem>(
			oldItems: fastIdentifiableTestScenario.oldItems,
			newItems: fastIdentifiableTestScenario.newItems,
			isEqualComparator: { ($0.ID == $1.ID) && ($0.property == $1.property) }
		)
		self.performTestWithContext(context, testScenario: fastIdentifiableTestScenario) {
			($0.ID == $1.ID) && ($0.property == $1.property)
		}
	}

	func testDiffWithDiffContextOfFastIdentifiableAndEquatableType() {
		let context = DiffContext<FastIdentifiableEquatableDiffedItem>(
			oldItems: fastIdentifiableEquatableTestScenario.oldItems,
			newItems: fastIdentifiableEquatableTestScenario.newItems
		)
		self.performTestWithContext(context, testScenario: fastIdentifiableEquatableTestScenario)
	}

	func testIndexDiffWithOneInsertion() {
		let a = [
			"1",
			"2",
			"3",
			"4",
		]
		let b = [
			"1",
			"NEW",
			"2",
			"3",
			"4",
		]
		let context = DiffContext(oldItems: a, newItems: b)
		let indexDiff = IndexDiff(context)
		expect(indexDiff.addedIndexes) == [1]
		expect(indexDiff.removedIndexes) == []
		expect(indexDiff.updatedIndexes) == []
		expect(indexDiff.movedIndexes.count) == 0
	}
}

extension String: FastIdentifiable {
	public var ID: String { return self }
}
