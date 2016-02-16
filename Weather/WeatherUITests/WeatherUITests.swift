//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest

class WeatherUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatCitiesExist() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Cities"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery.staticTexts["Suffield"].swipeUp()
        tablesQuery2.cells.containingType(.StaticText, identifier:"Lynn Lake").childrenMatchingType(.StaticText).matchingIdentifier("Lynn Lake").elementBoundByIndex(0).swipeUp()
        tablesQuery.staticTexts["Richer"].tap()
        app.navigationBars["Cities"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
    }
    
}
