//
//  FeedEntry.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-15.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class FeedEntry {
    var url: NSURL!
    var city: String!
    var province: String!
    
    init() {
        self.url = NSURL()
        self.city = ""
        self.province = ""
    }
    
    init(url: NSURL, city: String, province: String) {
        self.url = url
        self.city = city
        self.province = province
    }
    
    func isEmpty() -> Bool {
        return self.url.host == nil && !self.city.isEmpty && !self.province.isEmpty
    }
}