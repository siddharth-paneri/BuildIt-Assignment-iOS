//
//  DataProvider.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// Class used for data interpretations and database interactions only

import Foundation


class DataProvider {
    
    /** Method used to fetch a specifc city by city Id from database */
    func fetchCity(with id: Int64) -> CityEntity? {
        return CityEntity.fetchCity(with: id)
    }
    
    /** Method used to fetch all the cities from database */
    func fetchSavedCities() -> [CityEntity] {
        return CityEntity.fetchAll()
    }
    
    /** Method used to save city object in database */
    func save(city: CityDataModel) {
        _ = CityEntity.create(with: city)
    }
    
    /** Method used to fetch forecast entity from specific city id */
    func fetchForecasts(forCityId id: Int64) -> [ForecastEntity] {
        return ForecastEntity.fetchForecast(forCityId: id)
    }
    
    
    /** Method used to remove city from database of specfc city Id */
    func removeCity(with id: Int64) -> Bool {
        return CityEntity.removeCity(with: id)
    }
    
    /** Method used to fetch forecast data from API if required else from DB */
    func fetchForecastData(for cityId: Int64, lastFetch: Int64, _ completionHandler: @escaping ([ForecastEntity]?, WeatherError?)->()) {
        print(#function)
        // check if last fetch of forecast for this city was way before buffer date
        // if yes fetch from api else fetch from db
        let currentTime = Int64(Date().timeIntervalSince1970)
        if lastFetch > 0 && currentTime-lastFetch < FETCH_BUFFER {
            print("Fetch from DB")
            let forecasts = fetchForecasts(forCityId: cityId)
            completionHandler(forecasts, nil)
            return
        }
        print("Fetch from API")
        CommsProvider.sharedInstance.requestWeatherData(for: cityId) { [weak self] (response, weatherError) in
            if let error = weatherError {
                completionHandler(nil, error)
                return
            }
            guard let resp = response else {
                completionHandler(nil, WeatherError.emptyResponse)
                return
            }
            // update city entity with forecasts
            _ = CityEntity.updateForecastData(timestamp: currentTime, resp)
            
            guard let weakSelf = self else {
                return
            }
            // fetch forecasts from db
            let forecasts = weakSelf.fetchForecasts(forCityId: cityId)
            completionHandler(forecasts, nil)
            
            
        }
    }
    
}
