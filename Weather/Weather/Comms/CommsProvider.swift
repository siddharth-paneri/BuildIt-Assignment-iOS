//
//  CommsProvider.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// Class used for API callinf and network layer interactions only.

import Foundation
import Alamofire

class CommsProvider {
    
    // singleton
    private static var _sharedInstance: CommsProvider? = nil
    class var sharedInstance: CommsProvider {
        guard let shared = _sharedInstance else {
            _sharedInstance = CommsProvider()
            return _sharedInstance!
        }
        return shared
    }
    
    
    // this method is used to fetch the forecast data based on city id
    func requestWeatherData(for cityId: Int64, _ completionHandler: @escaping (Any?, WeatherError?)->()) {
        print(#function)
        let strURL = BASE_URL
        let params: [String: Any] = [PARAMS_CITY_ID: cityId,
                                     PARAMS_APP_ID: APP_ID,
                                     PARAMS_UNITS: "metric"]
        Alamofire.request(strURL, parameters: params, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
            if let result = response.result.value {
                completionHandler(result, nil)
            } else if let _ = response.result.error {
                completionHandler(nil, WeatherError.networkError)
            } else {
                completionHandler(nil, WeatherError.emptyResponse)
            }
        }
    }
    
}
