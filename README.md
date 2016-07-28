# SwiftHelpers

## Usage

### Diff

Best and easiest way to use Diffs is to implement `FastIdentifiable` and `Equatable` protocols.

```swift
extension MyType: FastIdentifiable, Equatable {
  …
}

let oldItems: [MyType] = …
let newItems: [MyType] = …

let context = DiffContext(oldItems: oldItems, newItems: newItems)

let diff = Diff(context)
diff.added // contains added items
diff.removed // contains removed items
diff.updated // contains updated items

let indexDiff = IndexDiff(context)
indexDiff.addedIndexes // indexes at which items were added
indexDiff.removedIndexes // indexes from which items were removed
indexDiff.updatedIndexes // indexes at which items were updated
indexDiff.movedIndexes // indexes from and to which items were moved
```

If for any reason you can't or do not want to conform to `Equatable` or `FastIdentifiable` protocol *(e.g. protocol extensions cannot have inheritance clause yet)*, you can always drop down to more verbose `DiffContext` initializers, all the way down to the most general one:

```swift
DiffContext.init(oldItems: [T],
                 newItems: [T],
                 oldItemsContainItem: T -> Bool,
                 newItemsContainItem: T -> Bool,
                 oldItemWithSameIDAsItem: T -> T?,
                 newItemWithSameIDAsItem: T -> T?,
                 isSameInstanceComparator: (T, T) -> Bool,
                 isEqualComparator: (T, T) -> Bool)
```

### UIControl+Blocks

Block-based `UIControl` extension instead of the classic target-action.

```
let token = control.addActionForControlEvents(.TouchUpInside) { (sender, event) in
  // handle touchUpInside
}

// If you want to be able to unregister action handler
// you need to keep the returned token around and call
control.removeActionWithToken(token)
```

### CGImage+Drawing

Convenience method, that sets up a `CGContext` to draw to and returns a `CGImage`.

```swift
let image = try CGImage.imageWithSize(CGSizeMake(256, 256)) { (context, size) in
  // Just draw to context with your usual Core Graphics code.
  // On iOS CGContext's coordinate space will be automatically flipped and translated so that (0, 0) is at the top-left corner.
}
```

### Optional+Convenience

#### iff
```swift
let optional: Optional<T>
optional.iff { object in
  // called synchronously only if optional == .Some(T)
  // object is the wrapped value
  // if optional == .None, nothing happens
}
```

#### unwrapped
```swift
//let optional: String?
let string = try optional.unwrapped() // will throw if optional is nil
```
```swift
try optional.unwrapped(throwing: myError) // provide custom error you wish to be thrown
```

## Installation

To install it, simply add the following lines to your Podfile:

```ruby
source 'https://github.com/bartekchlebek/Specs.git'
pod 'SwiftHelpers'
```

## Author

Bartek Chlebek, bartek.chlebek@gmail.com

## License

SwiftHelpers is available under the MIT license. See the LICENSE file for more info.
