// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import XCTest

final class SampleUITests: XCTestCase {
    func test_visibleViewController_is_loadedFromXIB_on_App_launch() throws {
        let window = makeSUT().windows.firstMatch
        let visibleViewController = window.otherElements["XIB"]
        XCTAssertTrue(visibleViewController.waitForExistence(timeout: 5))
    }
    
    func test_visibleViewController_is_programaticOne_on_tap_barButton2() throws {
        let app = makeSUT()
        app.buttons["2"].tap()
        let visibleViewController = getVisibleElement(identifier: "PRO", from: app)
        XCTAssertTrue(visibleViewController.waitForExistence(timeout: 5))
    }
    
    func test_visibleViewController_is_inheritedOne_on_tap_barButton3() throws {
        let app = makeSUT()
        app.buttons["3"].tap()
        let visibleViewController = getVisibleElement(identifier: "IN", from: app)
        XCTAssertTrue(visibleViewController.waitForExistence(timeout: 5))
    }
    
    // MARK: Helpers
    private func makeSUT() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }
    
    private func getVisibleElement(identifier: String, from app: XCUIApplication) -> XCUIElement {
        app.windows.firstMatch.otherElements["\(identifier)"]
    }
}
