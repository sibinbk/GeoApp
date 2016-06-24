//
//  CountryDetailViewController.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import UIKit
import MapKit

class CountryDetailViewController: UITableViewController, MKMapViewDelegate {

    @IBOutlet var continentLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var coastLineLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var birthRateLabel: UILabel!
    @IBOutlet var deathRateLabel: UILabel!
    @IBOutlet var lifeExpectancyLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var continentBackgroundView: UIView!
    @IBOutlet var populationGroundView: UIView!
    @IBOutlet var currencyBackgroundView: UIView!
    @IBOutlet var contentView: UIView!
    
    var country: Country?
    
    internal var regionRadius: CLLocationDistance = 1000000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let continent = country!.continent {
            continentLabel.text = continent
            let colorString = country!.colorStringForContinent(continent)
            tableView.backgroundColor = UIColor(colorCode: colorString, alpha: 1.0)
            contentView.backgroundColor = UIColor(colorCode: colorString, alpha: 0.4)
            continentBackgroundView.backgroundColor = UIColor(colorCode: colorString, alpha: 1.0)
            populationGroundView.backgroundColor = UIColor(colorCode: colorString, alpha: 1.0)
            currencyBackgroundView.backgroundColor = UIColor(colorCode: colorString, alpha: 1.0)
        }
                
        if let area = country!.area {
            // Zoom In map view if area is small.
            if area.intValue <= 5000 {
                regionRadius = 100000
            }
            areaLabel.text = area.stringValue + " sq km"
        }
        
        if let coastLine = country!.coastLine {
            coastLineLabel.text = coastLine.stringValue + " km"
        }
        
        if let population = country!.populaton {
            populationLabel.text = population.stringValue
        }
        
        if let birthRate = country!.birthRate {
            birthRateLabel.text = birthRate.stringValue + " %"
        }

        if let deathRate = country!.deathRate {
            deathRateLabel.text = deathRate.stringValue  + " %"
        }

        if let lifeExpectancy = country!.lifeExpectancy {
            lifeExpectancyLabel.text = lifeExpectancy.stringValue
        }
        
        if let currency = country!.currency {
            currencyLabel.text = currency
        }
        
        if let currencyCode = country!.currencyCode {
            currencyCodeLabel.text = currencyCode
        }

        let latitude = Double(country!.latitude!)
        let longitude = Double(country!.longitude!)
        centerMapOnLocation(latitude: latitude, longitude: longitude)
    }
    
    func centerMapOnLocation(latitude latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        mapView.addAnnotation(objectAnnotation)
    }
}


