//
//  CountryListViewController.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import UIKit
import CoreData

class CountryListViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    private let ReuseIdentifierCell = "CountryListCell"
    private let DetailSegue = "DetailSegue"
    
    private var countryList: [Country] = []
    var searchResults = [Country]()
    var resultSearchController: UISearchController!
    
//    internal var context: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Country")
        
        // Add sort descriptors.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search controller
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        // Determines where to present search controller.
        self.definesPresentationContext = true
        
        // Load country list from data base.
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error while fetching data")
            
        }
    }

    // MARK: - Table view data source method.

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sectionCount = fetchedResultsController.sections?.count {
            return sectionCount
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.resultSearchController.active {
            return self.searchResults.count
        } else {
            if let sections = fetchedResultsController.sections {
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
            }
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifierCell, forIndexPath: indexPath) as! CountryListTableViewCell

        // Configure Table View Cell
        configureCell(cell, atIndexPath: indexPath)
        
//        let country: Country
//        if self.resultSearchController.active {
//            country = self.searchResults[indexPath.row]
//        } else {
//            country = fetchedResultsController.objectAtIndexPath(indexPath) as! Country
//        }
//
//        cell.textLabel?.text = country.name
//        
//        // Sets Cell backgroud color  and weather icon as per weather condition.
//        if let continent = country.continent {
//            let colorString = self.colorStringForContinent(continent)
//            cell.contentView.backgroundColor = UIColor(colorCode: colorString, alpha: 1.0)
//        } else {
//            cell.contentView.backgroundColor = UIColor(colorCode: "34495E", alpha: 1.0)
//        }

        
        return cell
    }
    
    func configureCell(cell: CountryListTableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let country: Country
        if self.resultSearchController.active {
            country = self.searchResults[indexPath.row]
        } else {
            country = fetchedResultsController.objectAtIndexPath(indexPath) as! Country
        }
        
        if let name = country.name {
            cell.countryNameLabel.text = name
        }
        
        if let continent = country.continent {
            cell.continentNameLabel.text = continent
            let colorString = self.colorStringForContinent(continent)
            cell.countryCodeView.backgroundColor = UIColor(colorCode: colorString, alpha: 1.0)
        }
        
        if let countryCode = country.code {
            cell.countryCodeLabel.text = countryCode
        }
    }
    
    // MARK: - Table view delegate method.
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let country: Country
        if self.resultSearchController.active {
            country = self.searchResults[indexPath.row]
        } else {
            country = fetchedResultsController.objectAtIndexPath(indexPath) as! Country
        }
        
        performSegueWithIdentifier(DetailSegue, sender: country)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Fetched Results Controller Delegate Methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }

    // MARK: - Search Results Update method
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchResults.removeAll(keepCapacity: false)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Country")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchController.searchBar.text!)
        fetchRequest.predicate = searchPredicate
        
        do {
            if let results = try context.executeFetchRequest(fetchRequest) as? [Country] {
                searchResults = results
            }
        } catch {
            fatalError("Error while fetching country list")
        }
        
        tableView.reloadData()
    }

    // MARK: - Navigation method.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            if let destination = segue.destinationViewController as? CountryDetailViewController {
                destination.country = sender as? Country
            }
        }
    }
    
    // MARK: - Helper methods.
    
    func colorStringForContinent(continent: String) -> String {
        var colorString: String
        
        switch continent {
        case "Asia":
            // Orange
            colorString = "F39C12"
            break
        case "Africa":
            // Belize Hole (Dark Blue)
            colorString = "1ABC9C"
            break
        case "Europe":
            // Peter Rive (Light Blue)
            colorString = "3498DB"
            break
        case "North America":
            // Dark blue Material color
            colorString = "01579B"
            break
        case "South America":
            // Light Gray
            colorString = "5C5470"
            break
        case "Central America":
            // Dark gray
            colorString = "352F44"
            break
        case "Antartica":
            // Turquoise
            colorString = "2980B9"
            break
        case "Oceania":
            colorString = "7F8C8D"
            break
        case "Australia":
            colorString = "CD9D77"
            break
        default:
            // Wet Asphalt
            colorString = "34495E"
        }
        
        return colorString
    }
}

// HEX string to UIColor conversion extension

extension UIColor {
    convenience init(colorCode: String, alpha: Float = 1.0){
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}

