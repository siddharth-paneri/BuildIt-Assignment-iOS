//
//  Cons.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

// Base urls and appIds
let BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"
let BASE_URL_IMAGE = "http://openweathermap.org/img/w/"
let APP_ID = "5a3d5b382841656c4062aaab01257780"

// Parametres keys in APIs
let PARAMS_CITY_ID = "id"
let PARAMS_APP_ID = "APPID"
let PARAMS_UNITS = "units"


// Constants
let MASTER_CITY_LIST = "CityList_v1"
let CITIES_FILE_VERSION = "1"
let CITIES_FILE_VERSION_KEY = "CitiesFileVersionKey"
let CITY_LIST_VERSION = "1"
let MODEL: String = "Weather"
let DB_VERSION: String = "DB_VERSION"
let FETCH_BUFFER: Int64 = 3*60*60


//NOTIFICATION OBSERVERS
let NOTIF_ORIENTATION_CHANGED_TO_PORTRAIT = "OrientationChangedToProtrait"
let NOTIF_ORIENTATION_CHANGED_TO_LANDSCAPE = "OrientationChangedToLandscape"
