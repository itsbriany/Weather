//
//  ViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, NSXMLParserDelegate {

    // MARK: Properties
    @IBOutlet weak var textView: UITextView!
    
    var parser: NSXMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: NSXMLParserDelegate Implementation
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        NSLog("Found element")
        // TODO display the current weather conditions and the short
        // version of the 7 day forecast. i.e. get the title attribute
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
    }
    
    
    // MARK: Interface
    func getRSSFeed(url: NSURL) -> Bool {
        loadXMLParser(url)
        return self.parser.parse()
    }
    
    private func loadXMLParser(url: NSURL) {
        self.parser = NSXMLParser(contentsOfURL: url)
        self.parser.delegate = self
        self.parser.shouldResolveExternalEntities = false
    }
}

