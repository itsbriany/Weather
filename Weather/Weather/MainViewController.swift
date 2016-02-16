//
//  MainViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Identifiers
    static let WeatherEntryCellIdentifier = "WeatherEntryCell"
    static let DetailsViewSegueIdentifier = "DetailsSegue"
    static let MapViewSegueIdendifier = "MapSegue"
    
    
    // MARK: Properties
    @IBOutlet weak var currrentWeatherEntryTextView: UITextView!
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var weatherEntryTableView: UITableView!
    
    let geoCoder =  CLGeocoder()
    let dateTextViewFontSize: CGFloat = 18
    
    var locationManager: LocationManager = LocationManager()
    var forecastAI: ForecastAI = ForecastAI()
    var parser: FeedParser!
    var currentFeedEntry: FeedEntry?
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.locationManager.delegate = self
        self.dateTextView.font = UIFont.boldSystemFontOfSize(self.dateTextViewFontSize)
        let url = NSURL(string: "http://weather.gc.ca/rss/city/ns-19_e.xml")
        getRSSFeed(url!)
        updateCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableViewDataSource Implementation
    // How many cells?
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parser.entriesList.count
    }
    
    // Customize the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainViewController.WeatherEntryCellIdentifier, forIndexPath: indexPath) as! WeatherEntryCell
        updateWeatherEntryCell(cell, indexPath: indexPath)
        return cell
    }
    
    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateDateTextWhenLocationIsUpdated(manager, didUpdateLocations: locations, callback: { error -> Void in
            self.onLocationUpdate(error)
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location manager fail: " + error.description)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization Status updated")
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MainViewController.DetailsViewSegueIdentifier {
            prepareDetailsViewController(segue, sender: sender)
        } else if segue.identifier == MainViewController.MapViewSegueIdendifier {
            prepareMapViewController(segue, sender: sender)
        }
    }
    
    
    // MARK: User Interactions
    @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
        print("Unwind by going back")
        // Fetch another RSSFeed
        // Reload the weatherTable
    }
    
    @IBAction func unwindBySelectingCity(sender: UIStoryboardSegue) {
        if self.currentFeedEntry != nil {
            getRSSFeed(self.currentFeedEntry!.url)
        }
    }
    
    @IBAction func updateToLocalWeather(sender: UIBarButtonItem) {
        self.locationManager.prepareForReverseGeolocationLookup()
    }
    
    
    // MARK: Interface
    func getRSSFeed(url: NSURL) -> Bool {
        self.parser = FeedParser(url: url)
        let feedParsedSuccessfully = self.parser.parseFeed()
        
        updateView()
        
        return feedParsedSuccessfully
    }
    
    func updateWeatherEntryCell(cell: WeatherEntryCell, indexPath: NSIndexPath) {
        cell.titleTextView.text = self.parser.entriesList[indexPath.row].title
        cell.weatherEmojiLabel.text = extractWeatherConditionEmoji(cell, indexPath: indexPath)
    }
    
    func updateCurrentLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func getDateText() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d";
        let dateString = dateFormatter.stringFromDate(NSDate())
        return dateString
    }
    
    func updateDateTextWhenLocationIsUpdated(manager: CLLocationManager, didUpdateLocations locations: [CLLocation], callback: (error: NSError?) -> Void) {
        self.locationManager.handleLocationUpdate(manager, locations: locations, callback: {error -> Void in
            if error != nil {
                print("Error handling location update: " + error!.description)
                callback(error: error)
                return
            }
            let dateText = self.getDateText()
            self.dateTextView.text = self.locationManager.currentPlacemark!.locality! + " " + dateText
            callback(error: nil)
        })
    }
    
    
    // MARK: Helpers
    private func extractWeatherConditionEmoji(cell: WeatherEntryCell, indexPath: NSIndexPath) -> String {
        let text = self.parser.entriesList[indexPath.row].title
        if text != nil {
            let weatherCondition = self.forecastAI.getWeatherConditionFromText(text!)
            switch (weatherCondition) {
            case WeatherCondition.Cloudy:
                return "☁️"
            case WeatherCondition.Lightning:
                return "🌩"
            case WeatherCondition.Rainy:
                return "🌧"
            case WeatherCondition.Snowy:
                return "🌨"
            case WeatherCondition.Sunny:
                return "☀️"
            case WeatherCondition.SunnyCloudy:
                return "🌤"
            case WeatherCondition.Sunshower:
                return "🌦"
            case WeatherCondition.Tornado:
                return "🌪"
            case WeatherCondition.Windy:
                return "🌬"
            default:
                return "X"
            }
        }
        return "X"
    }
    
    private func prepareDetailsViewController(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! DetailsViewController
        if let selectedWeatherEntryCell = sender as? WeatherEntryCell {
            let indexPath = self.weatherEntryTableView.indexPathForCell(selectedWeatherEntryCell)
            let selectedWeatherEntry = self.parser.entriesList[indexPath!.row]
            controller.summaryText = selectedWeatherEntry.summary
        }
    }
    
    private func prepareMapViewController(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let mapViewController = navigationController.topViewController as? MapViewController {
                mapViewController.currentLocation = self.locationManager.location
            }
        }
    }
    
    private func updateView() {
        let weatherEntryList = self.parser.entriesList
        
        // TODO: The entries list may be a different size after loading another feed entry
        for entryIndex in 0 ..< weatherEntryList.count {
            let entry = weatherEntryList[entryIndex]
            if let entryTitle = entry.title {
                if entryTitle.lowercaseString.containsString(ForecastAI.CurrentWeatherConditionIdentifier) {
                    self.currrentWeatherEntryTextView.text = entryTitle + ForecastAI.DegreesUnit
                    self.parser.entriesList.removeAtIndex(entryIndex)
                }
            }
        }
        
        updateDateText()
        refreshWeatherEntryTable()
    }
    
    private func refreshWeatherEntryTable() {
        self.weatherEntryTableView.reloadData()
    }
    
    private func updateDateText() {
        if self.currentFeedEntry != nil {
            let dateText = self.getDateText()
            self.dateTextView.text = self.currentFeedEntry!.city + " " + dateText
        }
    }
    
    
    // MARK: Callbacks
    private func onLocationUpdate(error: NSError?) {
        if error != nil {
            print("CLLocationManagerDelegate didUpdateLocations error: " + error!.description)
            return
        }
        print("Location updated to " + self.locationManager.currentPlacemark!.locality!)
        self.currentFeedEntry = self.locationManager.extractFeedEntryFromGeolocation()
        if let url = self.currentFeedEntry!.url {
            getRSSFeed(url)
        }
        updateView()
    }
}