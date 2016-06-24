//
//  AppDelegate.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Preload the data and set a flag to avoid redownload.
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("isPreloaded")
        if !isPreloaded {
             preloadData()
            defaults.setBool(true, forKey: "isPreloaded")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sibinbk.GeoApp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("GeoApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - CSV Parsing Methods
    
    func parseCSV (contentsOfURL: NSURL, encoding: NSStringEncoding) -> [CountryItem]? {
        
        // Load the CSV file and parse it
        
        let delimiter = ","
        
        var countryItems:[CountryItem]?
        
        do {
            let content = try String(contentsOfURL: contentsOfURL, encoding: encoding)
            
            countryItems = []
            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    values = line.componentsSeparatedByString(delimiter)
                    
                    // Convert values into CountryItem and add it to the items array
                    let item = CountryItem(
                        name: values[0],
                        code: values[1],
                        continent: values[2],
                        population: (values[3] as NSString).integerValue,
                        area: (values[4] as NSString).integerValue,
                        coastLine: (values[5] as NSString).integerValue,
                        currency: values[6],
                        currencyCode: values[7],
                        birthRate: (values[8] as NSString).floatValue,
                        deathRate: (values[9] as NSString).floatValue,
                        lifeExpectancy: (values[10] as NSString).floatValue,
                        latitude: (values[11] as NSString).doubleValue,
                        longitude: (values[12] as NSString).doubleValue
                    )
                    countryItems?.append(item)
                }
            }
            
        } catch {
            print(error)
        }
        
        // Remove the header from the array.
        countryItems?.removeAtIndex(0)
        
        return countryItems
    }
    
    func preloadData () {
        
        // Load the data file. Just return if it can't be loaded.
        guard let contentsOfURL = NSBundle.mainBundle().URLForResource("data", withExtension: "csv") else {
            return
        }

        // Use code below instead, for direct download from internet.
//        guard let contentsOfURL = NSURL(string: "https://docs.google.com/uc?authuser=0&id=0B0Wb9VHlKucjSG90ak50QjJ0N00&export=download") else {
//            return
//        }
        
        // Remove all the country items before preloading
        removeData()
        
        if let items = parseCSV(contentsOfURL, encoding: NSMacOSRomanStringEncoding) {
            // Preload the Country list into CoreData
            for item in items {
                let countryItem = NSEntityDescription.insertNewObjectForEntityForName("Country", inManagedObjectContext: managedObjectContext) as! Country
                countryItem.name = item.name
                countryItem.code = item.code
                countryItem.continent = item.continent
                countryItem.population = item.population
                countryItem.area = item.area
                countryItem.coastLine = item.coastLine
                countryItem.currency = item.currency
                countryItem.currencyCode = item.currencyCode
                countryItem.birthRate = item.birthRate
                countryItem.deathRate = item.deathRate
                countryItem.lifeExpectancy = item.lifeExpectancy
                countryItem.latitude = item.latitude
                countryItem.longitude = item.longitude
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Error in loading")
                    print(error)
                }
            }
        }
    }
    
    func removeData () {
        // Remove the existing items
        let fetchRequest = NSFetchRequest(entityName: "Country")
        
        do {
            let countryItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Country]
            for countryItem in countryItems {
                managedObjectContext.deleteObject(countryItem)
            }
        } catch {
            print(error)
        }
    }
}

