//
//  CityViewModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// Class is a view model for City


import Foundation


class CityViewModel {
    private var _cityDataModel: CityDataModel
    private let dataProvider = DataProvider()
    
    init(with model: CityDataModel) {
        _cityDataModel = model
    }
    /** id of the city */
    var id: Int64 {
        return _cityDataModel.id
    }
    /** name of the city */
    var name: String {
        return _cityDataModel.name + ", " + _cityDataModel.country
    }
    
    /** last forecast fetch time for a city */
    var lastFetch: Int64 {
        return _cityDataModel.lastUpdateTimestamp
    }
  
    /** Remove a city from database */
    func remove()->Bool{
        return dataProvider.removeCity(with: _cityDataModel.id)
    }
}
