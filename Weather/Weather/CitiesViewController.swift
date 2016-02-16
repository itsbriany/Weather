//
//  CitiesViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-16.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Identifiers
    static let CityCellIdentifier = "CityCell"
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var csvParser: CSVParser!
    var feedEntries: [FeedEntry]!
    var currentFeedEntry: FeedEntry!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.csvParser = CSVParser(filePath: "feeds.csv")
        self.feedEntries = [FeedEntry]()
        fetchEntries()
    }
    
    
    // MARK: UITableViewDataSource Implementation
    // How many cells?
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedEntries.count
    }
    
    // Customize the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CitiesViewController.CityCellIdentifier, forIndexPath: indexPath) as! CityCell
        loadCityIntoCityCell(cell, indexPath: indexPath)
        return cell
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        prepareSegueForMainViewController(segue)
    }
    
    
    // MARK: Private Interface
    private func fetchEntries() {
        for (_, feedEntry) in self.csvParser.feedEntries {
            feedEntries.append(feedEntry)
        }
    }
    
    private func loadCityIntoCityCell(cell: CityCell, indexPath: NSIndexPath) {
        cell.cityLabel.text = self.feedEntries[indexPath.row].city
    }
    
    private func prepareSegueForMainViewController(segue: UIStoryboardSegue) {
        
        let mainViewController = segue.destinationViewController as! MainViewController
        let selectedIndexPath = self.citiesTableView.indexPathForSelectedRow
        let selctedCell = self.citiesTableView.cellForRowAtIndexPath(selectedIndexPath!) as! CityCell
        
        self.currentFeedEntry = self.csvParser.getEntryWithCity(selctedCell.cityLabel!.text!)
        
        if !self.currentFeedEntry.isEmpty() {
            if let feedEntry = self.currentFeedEntry {
                mainViewController.currentFeedEntry = feedEntry
            }
        }
        
        print("CitiesViewController: Prepared for segue!")
    }
}
