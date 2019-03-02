//
//  Enum.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation


// used as app wide error code
enum WeatherError: Error {
    case networkError
    case parsingError
    case emptyResponse
    case unableToProcessRequest
    
    
    var tupple: (title: String, message: String?) {
        switch self {
        case .networkError:
            return ("Error", "Network error")
        case .parsingError:
            return ("Error", "Internal error, contact technical support")
        case .emptyResponse:
            return ("No data available", nil)
        case .unableToProcessRequest:
            return ("Unable to process request", nil)
        }
    }
}

// used for theme based calculations
enum Theme {
    enum Color: String {
        case blue = "#3F51B5"
    }
}
