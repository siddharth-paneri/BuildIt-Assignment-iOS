//
//  CityDataModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation


struct CityDataModel {
    var id: Int64
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double
    var forecasts: [ForecastDataModel]?
    var lastUpdateTimestamp: Int64
}
