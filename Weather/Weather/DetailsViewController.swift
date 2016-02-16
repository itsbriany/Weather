//
//  DetailsViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var summaryTextView: UITextView!
    
    var summaryText: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaryTextView.text = summaryText
    }

}
