//
//  WeatherEntryModel.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-11.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

public class WeatherEntryModel: NSCopying {
    
    // MARK: Properties
    var summary: String?
    var title: String?
    
    
    // MARK: Constructors
    init(weatherEntryModel: WeatherEntryModel) {
        self.summary = weatherEntryModel.summary
        self.title = weatherEntryModel.title
    }
    
    init(summary: String, title: String) {
        self.summary = summary
        self.title = title
    }
    
    init() {
        self.summary = ""
        self.title = ""
    }
    
    
    // MARK: NSCopying implementation
    @objc public func copyWithZone(zone: NSZone) -> AnyObject {
        return WeatherEntryModel(weatherEntryModel: self)
    }
    
    
    // MARK: Interface
    func reset() {
        self.summary?.removeAll()
        self.title?.removeAll()
    }
    
    func copy() -> WeatherEntryModel {
        return copyWithZone(nil) as! WeatherEntryModel
    }
    
}