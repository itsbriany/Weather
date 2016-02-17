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
    weak var currentFeedEntry: FeedEntry?
    var searchActive: Bool = false
    var filteredFeedEntries: [FeedEntry]!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.filteredFeedEntries = [FeedEntry]()
        self.csvParser = CSVParser(filePath: "feeds.csv")
        self.feedEntries = [FeedEntry]()
        fetchEntries()
    }
    
    // MARK: UISearchBarDelegate Implementation
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //searchFor(searchText)
        
        self.filteredFeedEntries = self.feedEntries.filter({feedEntry -> Bool in
            let tmp: NSString = feedEntry.city
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(self.filteredFeedEntries.count == 0){
            self.searchActive = false;
        } else {
            self.searchActive = true;
        }
        
        self.citiesTableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    
    
    
    // MARK: UITableViewDataSource Implementation
    // How many cells?
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return self.filteredFeedEntries.count
        }
        return self.feedEntries.count
    }
    
    // Customize the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CitiesViewController.CityCellIdentifier, forIndexPath: indexPath) as! CityCell
        if self.searchActive {
            loadCityIntoCityCell(cell, indexPath: indexPath, feedEntries: self.filteredFeedEntries)
            return cell
        }
        loadCityIntoCityCell(cell, indexPath: indexPath, feedEntries: self.feedEntries)
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
    
    private func loadCityIntoCityCell(cell: CityCell, indexPath: NSIndexPath, feedEntries: [FeedEntry]) {
        cell.cityLabel.text = feedEntries[indexPath.row].city
    }
    
    private func prepareSegueForMainViewController(segue: UIStoryboardSegue) {
        
        let mainViewController = segue.destinationViewController as! MainViewController
        
        if let selectedIndexPath = self.citiesTableView.indexPathForSelectedRow {
            let selctedCell = self.citiesTableView.cellForRowAtIndexPath(selectedIndexPath) as! CityCell
            
            self.currentFeedEntry = self.csvParser.getEntryWithCity(selctedCell.cityLabel!.text!)
            
            if !self.currentFeedEntry!.isEmpty() {
                if let feedEntry = self.currentFeedEntry {
                    mainViewController.currentFeedEntry = feedEntry
                }
            }
        }
        
    }
}
