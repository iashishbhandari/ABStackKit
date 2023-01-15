//
//  SampleUITests.swift
//  SampleUITests
//
//  Created by Ashish Bhandari on 14/01/23.
//  Copyright © 2023 iashishbhandari. All rights reserved.
//

import XCTest

final class SampleUITests: XCTestCase {
    func test_visibleViewController_is_loadedFromXIB_on_App_launch() throws {
        let (_, window) = makeSUT()
        let visibleViewController = window.otherElements["XIB"]
        XCTAssertTrue(visibleViewController.waitForExistence(timeout: 5))
    }
    
    func test_visibleViewController_is_programaticOne_on_tap_barButton2() throws {
        let (app, window) = makeSUT()
        app.buttons["2"].tap()
        let visibleViewController = window.otherElements["PRO"]
        XCTAssertTrue(visibleViewController.waitForExistence(timeout: 5))
    }
    
    func test_visibleViewController_is_inheritedOne_on_tap_barButton3() throws {
        let (app, window) = makeSUT()
        app.buttons["3"].tap()
        let visibleViewController = window.otherElements["IN"]
        XCTAssertTrue(visibleViewController.waitForExistence(timeout: 5))
    }
    
    // MARK: Helpers
    func makeSUT() -> (XCUIApplication, XCUIElement) {
        let app = XCUIApplication()
        app.launch()
        return (app, app.windows.firstMatch)
    }
}
