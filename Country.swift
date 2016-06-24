//
//  Country.swift
//  GeoApp
//
//  Created by Sibin Baby on 25/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import Foundation
import CoreData


class Country: NSManagedObject {

    // Returns a color string  for each continent.
    
    func colorStringForContinent(continent: String) -> String {
        var colorString: String
        
        switch continent {
        case "Asia":
            colorString = "3498db"
            break
        case "Africa":
            colorString = "1ABC9C"
            break
        case "Europe":
            colorString = "9b59b6"
            break
        case "North America":
            colorString = "f39c12"
            break
        case "South America":
            colorString = "e74c3c"
            break
        case "Central America":
            colorString = "d35400"
            break
        case "Antartica":
            colorString = "2980B9"
            break
        case "Oceania":
            colorString = "7F8C8D"
            break
        case "Australia":
            colorString = "27ae60"
            break
        default:
            colorString = "34495E"
        }
        
        return colorString
    }


}
