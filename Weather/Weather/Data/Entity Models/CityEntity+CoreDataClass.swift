//
//  CityEntity+CoreDataClass.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CityEntity)
public class CityEntity: NSManagedObject {
    
    class func fetchCity(with id: Int64) -> CityEntity? {
        return CityEntity.find("id=\(id)") as? CityEntity
    }
    
    class func fetchAll() -> [CityEntity] {
        return CityEntity.all(sort: [["id":"ASC"]]) as! [CityEntity]
    }
    
    class func removeCity(with id: Int64) -> Bool{
        if let city = CityEntity.fetchCity(with: id) {
            city.delete()
            return city.save()
        }
        return false
    }
    
    class func create(with model: CityDataModel) -> Bool {
        
        var coreDataObj: NSManagedObject? = nil
        if let data = CityEntity.fetchCity(with: Int64(model.id)) {
            coreDataObj = data
        } else {
            coreDataObj = CityEntity.create()
        }
        
        guard let cityEntity = coreDataObj else {
            return false
        }
        cityEntity.setValue(Int64(model.id), forKey: "id")
        cityEntity.setValue(model.name, forKey: "name")
        cityEntity.setValue(model.country, forKey: "country")
        cityEntity.setValue(model.latitude, forKey: "latitude")
        cityEntity.setValue(model.longitude, forKey: "longitude")
        let entity = cityEntity.save()
        return entity
    }
    
    class func updateForecastData(timestamp: Int64, _ data: Any) -> Bool {
        if let jsonObj = data as? [String: Any] {
            if let cityJson = jsonObj["city"] as? [String: Any] {
                if let id = cityJson["id"] as? Int64 {
                    if let cityEntity = CityEntity.fetchCity(with: id) {
                        cityEntity.lastUpdateTimestamp = timestamp
                        if let forecastJson = jsonObj["list"] as? [[String: Any]] {
                            ForecastEntity.create(forecastJson, city: cityEntity)
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}
