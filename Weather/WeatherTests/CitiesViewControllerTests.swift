//
//  CitiesViewControllerTests.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-16.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import Weather

class CitiesViewControllerTests: XCTestCase {

    var controller: CitiesViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("CitiesViewNavigationController") as! UINavigationController
        self.controller = navigationController.topViewController as! CitiesViewController
        
        // Test and load the view at the same time
        XCTAssertNotNil(navigationController.view, "MainViewNavigationController's view is nil")
        XCTAssertNotNil(self.controller.view, "CitiesViewController's view is nil")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatCitiesTableViewExists() {
        XCTAssertNotNil(self.controller.citiesTableView)
    }
    
    func testThatCitiesTableViewHasDelegate() {
        XCTAssertNotNil(self.controller.citiesTableView.delegate)
    }
    
    func testThatCitiesTableViewHasDataSource() {
        XCTAssertNotNil(self.controller.citiesTableView.dataSource)
    }
    
    func testThatCitiyCellsExist() {
        let expectedCells = self.controller.feedEntries.count
        XCTAssertEqual(self.controller.citiesTableView.numberOfRowsInSection(0), expectedCells)
    }
    
    func testThatCitiesTableViewWillCreateDataSourceWithReuseIdentifier() {
        let expectedReuseIdentifier = CitiesViewController.CityCellIdentifier
        let cell = self.controller.citiesTableView.dequeueReusableCellWithIdentifier(expectedReuseIdentifier) as! CityCell
        XCTAssertNotNil(cell)
    }
    
    func testThatFeedEntriesCanBeLoaded() {
        XCTAssertGreaterThan(self.controller.feedEntries.count, 0)
    }
    
    func testThatFeedEntryHoldsValue() {
        let feedEntry = self.controller.feedEntries[0]
        XCTAssertNotNil(feedEntry)
        XCTAssertFalse(feedEntry.city.isEmpty)
        XCTAssertFalse(feedEntry.province.isEmpty)
        XCTAssertNotNil(feedEntry.url)
    }
}
