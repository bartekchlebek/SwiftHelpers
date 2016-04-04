import XCTest
import Nimble
import SwiftHelpers
import UIKit

final class UIControl_BlocksTests: XCTestCase {

	func testAddingActions() {
		var touchDownCallbackCount = 0
		var touchUpCallbackCount = 0

		let control = UIControl()

		let touchDownToken = control.addActionForControlEvents(.TouchDown) { (sender, event) in
			touchDownCallbackCount += 1
		}

		let touchUpToken = control.addActionForControlEvents(.TouchUpInside) { (sender, event) in
			touchUpCallbackCount += 1
		}

		control.sendActionsForControlEvents(.TouchDown)
		expect(touchDownCallbackCount) == 1
		expect(touchUpCallbackCount) == 0

		control.sendActionsForControlEvents(.TouchUpInside)
		expect(touchDownCallbackCount) == 1
		expect(touchUpCallbackCount) == 1

		expect(touchDownToken).toNot(beNil())
		expect(touchUpToken).toNot(beNil())
	}

	func testActionBlockParameters() {
		let control = UIControl()

		let touchDownToken = control.addActionForControlEvents(.TouchDown) { [weak control] (sender, event) in
			// event is falsly nil because sendActionsForControlEvents doesn't create one
			expect(sender) == control
		}

		control.sendActionsForControlEvents(.TouchDown)
		expect(touchDownToken).toNot(beNil())
	}

	func testRemovingActionsOnTokenDeinit() {
		var callbackCount = 0

		let control = UIControl()
		var token: UIControl.ActionToken? = control.addActionForControlEvents(.TouchUpInside) { (sender, event) in
			callbackCount += 1
		}
		expect(token).toNot(beNil())

		control.sendActionsForControlEvents(.TouchUpInside)
		expect(callbackCount) == 1

		token = nil
		control.sendActionsForControlEvents(.TouchUpInside)
		expect(callbackCount) == 1
	}

	func testBindingActionToLifecycleOfAnotherObject() {
		var callbackCount = 0
		var object: NSObject? = NSObject()

		let control = UIControl()
		control.addActionForControlEvents(.TouchDown, removedOnDeinitOf: object!) {
			[weak object] (sender, event, boundObject) in
			expect(boundObject) == object
			callbackCount += 1
		}

		control.sendActionsForControlEvents(.TouchDown)
		expect(callbackCount) == 1

		object = nil
		control.sendActionsForControlEvents(.TouchDown)
		expect(callbackCount) == 1
	}
}
