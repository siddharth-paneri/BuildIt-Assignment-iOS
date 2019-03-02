//
//  WeatherEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: Int16
    @NSManaged public var main: String?
    @NSManaged public var forecast: ForecastEntity?

}
