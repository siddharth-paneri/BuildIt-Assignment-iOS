//
//  CitiesViewModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// Class is the list of cities i.E Cities View models, and used of other operations on list

import Foundation

class CitiesViewModel {
    
    private var _citiesViewModel: [CityViewModel] = []
    private let dataProvider = DataProvider()
    
    var didUpdate: (()->())? = nil
    var didFail: ((WeatherError?)->())? = nil
    
    /** Count of city view model objects */
    var count: Int {
        return _citiesViewModel.count
    }
    
    /** Provides city view model and given index */
    func viewModel(at index: Int) -> CityViewModel? {
        if count > 0 && index >= 0 && index < count {
            return _citiesViewModel[index]
        }
        return nil
    }
    
    /** Fetchs all city View models and send updates later */
    func fetchCities() {
        fetchStoredCitites()
        self.didUpdate?()
    }
    
    /** Fethcs all stored city view models from DB */
    private func fetchStoredCitites() {
        let cityEntities = dataProvider.fetchSavedCities()
        let cityDataModels = DataModelParser.parse(cityEntities: cityEntities)
        _citiesViewModel = ViewModelParser.parse(cityDataModels: cityDataModels)
    }
    
    /** Removes the city view model and finaly city from DB */
    func remove(city: CityViewModel) -> Bool{
        
        let value = city.remove()
        fetchStoredCitites()
        return value
        
    }
    
}
