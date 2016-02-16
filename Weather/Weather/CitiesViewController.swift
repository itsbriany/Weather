//
//  CitiesViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-16.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: Identifiers
    static let CityCellIdentifier = "CityCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var csvParser: CSVParser!
    var feedEntries: [FeedEntry]!
    var currentFeedEntry: FeedEntry!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.csvParser = CSVParser(filePath: "feeds.csv")
        self.feedEntries = [FeedEntry]()
        fetchEntries()
    }
    
    // MARK: Interface
    func searchFor(city: String) {
        // TODO: Only visible cells can be queried
        // Need to query the feedEntries
        
        var foundEntries = collectFeedEntriesContainingCity(city)
        
        for var section = 0; section < self.citiesTableView.numberOfSections; section++ {
            for var row = 0; row < self.citiesTableView.numberOfRowsInSection(section); row++ {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                if let cell = self.citiesTableView.cellForRowAtIndexPath(indexPath) as? CityCell {
                    if !foundEntries.isEmpty {
                        cell.cityLabel.text = foundEntries.popLast()?.city
                    }
                }
            }
        }
    }
    
    // MARK: UISearchBarDelegate Implementation
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(searchText)
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
    private func collectFeedEntriesContainingCity(city: String) -> [FeedEntry] {
        var localFeedEntries = [FeedEntry]()
        for feedEntry in self.feedEntries {
            let feedEntryCity = feedEntry.city
            if feedEntryCity.lowercaseString.containsString(city.lowercaseString) {
                localFeedEntries.append(feedEntry)
            }
        }
        return localFeedEntries
    }
    
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
        
        if let selectedIndexPath = self.citiesTableView.indexPathForSelectedRow {
            let selctedCell = self.citiesTableView.cellForRowAtIndexPath(selectedIndexPath) as! CityCell
            
            self.currentFeedEntry = self.csvParser.getEntryWithCity(selctedCell.cityLabel!.text!)
            
            if !self.currentFeedEntry.isEmpty() {
                if let feedEntry = self.currentFeedEntry {
                    mainViewController.currentFeedEntry = feedEntry
                }
            }
        }
        
    }
}
