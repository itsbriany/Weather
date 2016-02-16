//
//  CSVParserTests.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-15.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import Weather

class CSVParserTests: XCTestCase {
    
    var parser: CSVParser!
    
    override func setUp() {
        super.setUp()
        self.parser = CSVParser(filePath: "feeds.csv")
        XCTAssertNotNil(parser, "CSVParser is nil")
        XCTAssertGreaterThan(self.parser.feedEntries.count, 0)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatCSVFileCanBeLoaded() {
        XCTAssertNotNil(self.parser.feedData)
        XCTAssertFalse(self.parser.feedData!.isEmpty)
    }
    
    func testThatEntriesCanBeLoaded() {
        XCTAssertNotNil(self.parser.feedEntries)
        XCTAssertGreaterThan(self.parser.feedEntries.count, 0)
        
        var targetCity = "Toronto"
        var feedEntry = self.parser.getEntryWithCity(targetCity)
        XCTAssertNotNil(feedEntry, "Feed entry is nil")
        XCTAssertFalse(feedEntry.isEmpty())
        XCTAssertEqual(feedEntry.url.host, "weather.gc.ca")
        XCTAssertEqual(feedEntry.url.path, "/rss/city/on-143_e.xml")
        XCTAssertFalse(feedEntry.city.isEmpty, "City in feed entry is empty")
        XCTAssertEqual(feedEntry.city.caseInsensitiveCompare(targetCity), NSComparisonResult.OrderedSame)
        XCTAssertFalse(feedEntry.province.isEmpty, "Province in feed entry is empty")
        XCTAssertEqual(feedEntry.province, "Ontario")
        
        targetCity = "HalIfAx"
        feedEntry = self.parser.getEntryWithCity(targetCity)
        XCTAssertEqual(feedEntry.url.host, "weather.gc.ca")
        XCTAssertFalse(feedEntry.isEmpty())
        XCTAssertEqual(feedEntry.url.path, "/rss/city/ns-19_e.xml")
        XCTAssertFalse(feedEntry.city.isEmpty, "City in feed entry is empty")
        XCTAssertEqual(feedEntry.city.caseInsensitiveCompare(targetCity), NSComparisonResult.OrderedSame)
        XCTAssertFalse(feedEntry.province.isEmpty, "Province in feed entry is empty")
        XCTAssertEqual(feedEntry.province, "Nova Scotia")
    }
    
}
