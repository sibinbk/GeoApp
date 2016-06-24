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
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var country: Country?
    
    private let regionRadius: CLLocationDistance = 1000000
    
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
