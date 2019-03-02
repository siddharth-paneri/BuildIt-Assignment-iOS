//
//  WindEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension WindEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindEntity> {
        return NSFetchRequest<WindEntity>(entityName: "WindEntity")
    }

    @NSManaged public var degree: Double
    @NSManaged public var speed: Double
    @NSManaged public var forecast: ForecastEntity?

}
