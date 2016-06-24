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
        let cell = tableView.dequeueReusableCellWithIdentifier("CountryListCell", forIndexPath: indexPath)

        let country = fetchedResultsController.objectAtIndexPath(indexPath) as! Country

        cell.textLabel?.text = country.name
        
        return cell
    }
    
    // MARK: - Table view delegate method.
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let country = fetchedResultsController.objectAtIndexPath(indexPath) as! Country
        
        performSegueWithIdentifier("DetailSegue", sender: country)
        
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
            fatalError("Error while fetching venue list")
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
}
