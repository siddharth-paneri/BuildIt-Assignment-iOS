//
//  Cities.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// Class can be used to fetch all the cities from cities file and stored in ram, for performance improvement.
// the cities will be stored in ram until next launch

import Foundation


class Cities {
    
    // singleton
    private static var _sharedInstance: Cities? = nil
    class var sharedInstance: Cities {
        guard let shared = _sharedInstance else {
            _sharedInstance = Cities()
            return _sharedInstance!
        }
        return shared
    }
    
    private var _cities: [CityFileModel] = []
    
    init() {
        // load all data fron stored cities json
    }
    
    // fetch all cities from private object
    func all()->[CityFileModel] {
        return _cities
    }
    
    /** load all cities from given file */
    func loadCitiesIfRequired(_ completionHandler: ([CityFileModel])->()) {
        print(#function)
        if _cities.isEmpty {
            loadCities(from: "CityList_v\(CITIES_FILE_VERSION)", completionHandler)
        } else {
            completionHandler(_cities)
        }
        
        
    }
    
    
    /** Load all cities from cities file with file name */
    func loadCities(from file: String, _ completionHandler: ([CityFileModel])->()) {
        // fetch json file
        print(#function)
        if let jsonData = JSONReader.read(file: file) {
            do {
                _cities = try JSONDecoder().decode([CityFileModel].self, from: jsonData)
                UserDefaults.standard.set(CITIES_FILE_VERSION, forKey: CITIES_FILE_VERSION_KEY)
                print("Loaded all cities")
                completionHandler(_cities)
            } catch {
                print("could not parse cities")
                _cities = []
                completionHandler(_cities)
            }
        } else {
            _cities = []
            print("Either file not found or empty file found")
            completionHandler([])
        }
    }
}
