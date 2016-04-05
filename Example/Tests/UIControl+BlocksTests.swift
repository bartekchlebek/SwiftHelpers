import XCTest
import Nimble
import SwiftHelpers
import UIKit

final class UIControl_BlocksTests: XCTestCase {

	func testAddingActions() {
		var touchDownCallbackCount = 0
		var touchUpCallbackCount = 0

		let control = UIControl()

		control.addActionForControlEvents(.TouchDown) { (sender, event) in
			touchDownCallbackCount += 1
		}

		control.addActionForControlEvents(.TouchUpInside) { (sender, event) in
			touchUpCallbackCount += 1
		}

		control.sendActionsForControlEvents(.TouchDown)
		expect(touchDownCallbackCount) == 1
		expect(touchUpCallbackCount) == 0

		control.sendActionsForControlEvents(.TouchUpInside)
		expect(touchDownCallbackCount) == 1
		expect(touchUpCallbackCount) == 1
	}

	func testActionBlockParameters() {
		let control = UIControl()

		control.addActionForControlEvents(.TouchDown) { [weak control] (sender, event) in
			// event is falsly nil because sendActionsForControlEvents doesn't create one
			expect(sender) == control
		}

		control.sendActionsForControlEvents(.TouchDown)
	}

	func testRemovingActions() {
		var callbackCount = 0

		let control = UIControl()
		let token = control.addActionForControlEvents(.TouchUpInside) { (sender, event) in
			callbackCount += 1
		}

		control.sendActionsForControlEvents(.TouchUpInside)
		expect(callbackCount) == 1

		control.removeActionWithToken(token)
		control.sendActionsForControlEvents(.TouchUpInside)
		expect(callbackCount) == 1
	}

}
