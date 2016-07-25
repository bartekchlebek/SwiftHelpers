import XCTest
import Nimble
import SwiftHelpers
import UIKit

final class UIControl_BlocksTests: XCTestCase {

	func testAddingActions() {
		var touchDownCallbackCount = 0
		var touchUpCallbackCount = 0

		let control = UIControl()

		control.addActionForControlEvents(.touchDown) { (sender, event) in
			touchDownCallbackCount += 1
		}

		control.addActionForControlEvents(.touchUpInside) { (sender, event) in
			touchUpCallbackCount += 1
		}

		control.sendActions(for: .touchDown)
		expect(touchDownCallbackCount) == 1
		expect(touchUpCallbackCount) == 0

		control.sendActions(for: .touchUpInside)
		expect(touchDownCallbackCount) == 1
		expect(touchUpCallbackCount) == 1
	}

	func testActionBlockParameters() {
		let control = UIControl()

		control.addActionForControlEvents(.touchDown) { [weak control] (sender, event) in
			// event is falsly nil because sendActionsForControlEvents doesn't create one
			expect(sender) == control
		}

		control.sendActions(for: .touchDown)
	}

	func testRemovingActions() {
		var callbackCount = 0

		let control = UIControl()
		let token = control.addActionForControlEvents(.touchUpInside) { (sender, event) in
			callbackCount += 1
		}

		control.sendActions(for: .touchUpInside)
		expect(callbackCount) == 1

		control.removeActionWithToken(token)
		control.sendActions(for: .touchUpInside)
		expect(callbackCount) == 1
	}

}
