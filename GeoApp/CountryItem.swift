//
//  CountryItem.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import Foundation

class CountryItem: NSObject {
    let name: String
    let code: String
    let continent: String
    let population: Int
    let area: Int
    let coastLine: Int
    let currency: String
    let currencyCode: String
    let birthRate: Float
    let deathRate: Float
    let lifeExpectancy: Float
    let latitude: Double
    let longitude: Double
    
    init(
        name:String,
        code:String,
        continent:String,
        population:Int,
        area:Int,
        coastLine:Int,
        currency:String,
        currencyCode:String,
        birthRate:Float,
        deathRate:Float,
        lifeExpectancy:Float,
        latitude:Double,
        longitude:Double
        )
    {
        self.name = name
        self.code = code
        self.continent = continent
        self.population = population
        self.area = area
        self.coastLine = coastLine
        self.currency = currency
        self.currencyCode = currencyCode
        self.birthRate = birthRate
        self.deathRate = deathRate
        self.lifeExpectancy = lifeExpectancy
        self.latitude = latitude
        self.longitude = longitude
    }
}
