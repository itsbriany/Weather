//
//  CSVParser.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-15.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

enum CSVParseException: ErrorType {
    case InvalidEntryFormat
    case InvalidURL
    case MissingData
    case NoSuchFeedEntry
}

class CSVParser {
    
    static let FeedEntriesFile = "feeds.csv"
    
    // MARK: Properties
    var feedEntries: [String : FeedEntry]!
    var feedData: String?
    
    
    init(filePath: String) {
        self.feedEntries = [String: FeedEntry]()
        do {
            try loadCSVData(filePath)
            try loadFeedEntries()
        } catch CSVParseException.InvalidEntryFormat {
            print("Found an invalid entry format")
            exit(EXIT_FAILURE)
        } catch CSVParseException.InvalidURL {
            print("Found an invalid URL")
            exit(EXIT_FAILURE)
        } catch CSVParseException.MissingData {
            print("The CSV file is empty!")
            exit(EXIT_FAILURE)
        } catch {
            print("Something went wrong when loading CSV entries!")
            exit(EXIT_FAILURE)
        }
    }
    
    
    // MARK: Interface
    func getEntryWithCity(city: String) throws -> FeedEntry {
        if feedEntries.isEmpty {
            throw CSVParseException.MissingData
        }
       
        if let entry = self.feedEntries[city.lowercaseString] {
            return entry
        }
        
        throw CSVParseException.NoSuchFeedEntry
    }
    
    
    // MARK: Private Interface
    private func loadCSVData(filePath: String) throws {
        do {
            let localFilePath = NSBundle.mainBundle().pathForResource(filePath, ofType: "")
            if let fileContents: NSString = try NSString(contentsOfFile: localFilePath!, encoding: NSUTF8StringEncoding) {
                self.feedData = fileContents as String
            }
        } catch {
            throw CSVParseException.MissingData
        }
    }
    
    private func loadFeedEntries() throws {
        if let stringEntries = self.feedData?.componentsSeparatedByString("\n") {
            for feedEntryString in stringEntries {
                let feedEntryComponents = feedEntryString.componentsSeparatedByString(",")
                if feedEntryComponents.count >= 3 {
                    if let url = NSURL(string: feedEntryComponents[0]) {
                        let city = feedEntryComponents[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        let province = feedEntryComponents[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        let feedEntry = FeedEntry(url: url, city: city, province: province)
                        self.feedEntries[city.lowercaseString] = feedEntry
                        continue
                    }
                    throw CSVParseException.InvalidURL
                }
                print("Invalid FeedEntry string: " + feedEntryString)
                throw CSVParseException.InvalidEntryFormat
            }
            return
        }
        throw CSVParseException.MissingData
    }
}