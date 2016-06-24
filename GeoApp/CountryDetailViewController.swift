//
//  CountryDetailViewController.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import UIKit

class CountryDetailViewController: UITableViewController {

    @IBOutlet var continentLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let continent = country!.continent {
            continentLabel.text = continent
        }
        
        if let population = country!.populaton {
            populationLabel.text = population.stringValue
        }
        
        if let latitude = country!.latitude {
            latitudeLabel.text = latitude.stringValue
        }
    }

}
