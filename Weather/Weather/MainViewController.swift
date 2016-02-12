//
//  MainViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var weatherEntryTableView: UITableView!
    let weatherEntryCellIdentifier = "WeatherEntryCell"
    var parser: FeedParser!
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://weather.gc.ca/rss/city/on-76_e.xml")
        getRSSFeed(url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableViewDataSource Implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parser.entriesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.weatherEntryCellIdentifier, forIndexPath: indexPath) as! WeatherEntryCell
        updateWeatherEntryCell(cell, indexPath: indexPath)
        return cell
    }
    
    
    // MARK: Interface
    func getRSSFeed(url: NSURL) -> Bool {
        self.parser = FeedParser(url: url)
        return self.parser.parseFeed()
    }
    
    func updateWeatherEntryCell(cell: WeatherEntryCell, indexPath: NSIndexPath) {
        cell.titleTextView.text = self.parser.entriesList[indexPath.row].title
    }
}

