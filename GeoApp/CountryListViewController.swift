//
//  CountryListViewController.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import UIKit
import CoreData

class CountryListViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController!
    private var countryList: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Load country list from database
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "Country")
            do {
                countryList = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Country]
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source method.

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CountryListCell", forIndexPath: indexPath)

        cell.textLabel?.text = countryList[indexPath.row].name

        return cell
    }
    
    // MARK: - Table view delegate method.
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let country: Country
        country = countryList[indexPath.row] as Country
        
        performSegueWithIdentifier("DetailSegue", sender: country)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
