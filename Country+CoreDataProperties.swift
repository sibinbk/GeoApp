//
//  Country+CoreDataProperties.swift
//  GeoApp
//
//  Created by Sibin Baby on 25/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var name: String?
    @NSManaged var code: String?
    @NSManaged var continent: String?
    @NSManaged var population: NSNumber?
    @NSManaged var area: NSNumber?
    @NSManaged var coastLine: NSNumber?
    @NSManaged var currency: String?
    @NSManaged var currencyCode: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var birthRate: NSNumber?
    @NSManaged var deathRate: NSNumber?
    @NSManaged var lifeExpectancy: NSNumber?

}
