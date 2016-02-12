//
//  FeedParser.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-11.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class FeedParser: NSObject, NSXMLParserDelegate {
    
    // MARK: Properties
    var XMLParser: NSXMLParser!
    var entriesList: [WeatherEntryModel]!
    var entryMap: [String : String]!
    var foundEntry: Bool = false
    var currentElement: String?
    var dummyWeatherEntry = WeatherEntryModel()
    
    init(url: NSURL) {
        super.init()
        self.XMLParser = NSXMLParser(contentsOfURL: url)
        self.XMLParser.delegate = self
        self.entryMap = [String : String]()
        self.entriesList = [WeatherEntryModel]()
    }
    
    // MARK: NSXMLParserDelegate Implementation
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "entry" {
            self.foundEntry = true
            return
        }
        
        if self.foundEntry {
            self.currentElement = elementName
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            self.entriesList.append(self.dummyWeatherEntry)
            self.foundEntry = false
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if !string.containsString("\n") {
            if self.currentElement == "title" && self.foundEntry {
                self.dummyWeatherEntry.title = string
            } else if self.currentElement == "summary" && self.foundEntry {
                self.dummyWeatherEntry.summary = string
            }
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("XML Parse error: " + parseError.description)
    }
    
    // MARK: Interface
    func parseFeed() -> Bool {
        return self.XMLParser.parse()
    }
}