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
        
        do {
            let targetCity = "Toronto"
            let feedEntry = try self.parser.getEntryWithCity(targetCity)
            XCTAssertNotNil(feedEntry, "Feed entry is nil")
            XCTAssertEqual(feedEntry.url.host, "weather.gc.ca")
            XCTAssertEqual(feedEntry.url.path, "/rss/city/on-143_e.xml")
            XCTAssertFalse(feedEntry.city.isEmpty, "City in feed entry is empty")
            XCTAssertEqual(feedEntry.city.caseInsensitiveCompare(targetCity), NSComparisonResult.OrderedSame)
            XCTAssertFalse(feedEntry.province.isEmpty, "Province in feed entry is empty")
            XCTAssertEqual(feedEntry.province, "Ontario")
        } catch CSVParseException.NoSuchFeedEntry {
            XCTAssertTrue(false, "Could not find the specified entry")
        } catch CSVParseException.MissingData {
            XCTAssertTrue(false, "CSV file is missing data")
        } catch {
            XCTAssertTrue(false, "Error.")
        }
        
        do {
            let targetCity = "HalIfAx"
            let feedEntry = try self.parser.getEntryWithCity(targetCity)
            XCTAssertEqual(feedEntry.url.host, "weather.gc.ca")
            XCTAssertEqual(feedEntry.url.path, "/rss/city/ns-19_e.xml")
            XCTAssertFalse(feedEntry.city.isEmpty, "City in feed entry is empty")
            XCTAssertEqual(feedEntry.city.caseInsensitiveCompare(targetCity), NSComparisonResult.OrderedSame)
            XCTAssertFalse(feedEntry.province.isEmpty, "Province in feed entry is empty")
            XCTAssertEqual(feedEntry.province, "Nova Scotia")
        } catch CSVParseException.NoSuchFeedEntry {
            XCTAssertTrue(false, "Could not find the specified entry")
        } catch CSVParseException.MissingData {
            XCTAssertTrue(false, "CSV file is missing data")
        } catch {
            XCTAssertTrue(false, "Error.")
        }
        
    }
    
}
