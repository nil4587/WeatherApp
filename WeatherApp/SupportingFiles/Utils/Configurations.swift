//
//  Configurations.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

struct Configurations {
    
    struct Keys {
        static let WeatherAPIKey = "d5bcea415cb59f1032ab835090072b00"
        static let GoogleAPIKey = ""
    }
    
    struct API {
        static let REQUEST_TIMEOUT: Double = 60
        static let FORECAST_API = "https://api.openweathermap.org/data/2.5/forecast?lat=%lf&lon=%lf&appid=%@"
        static let CURRENT_WEATHER_API = "https://api.openweathermap.org/data/2.5/weather?lat=%lf&lon=%lf&appid=%@"
        static let GEO_CODING_API = "https://api.openweathermap.org/geo/1.0/direct?q=%@&limit=5&appid=%@"
    }
    
    /// A structure which keeps web-service request's keys
    struct RequestHeaderKey {
        static let ContentType_Key = "Content-Type"
        static let ContentType_Value = "application/json"
        static let Cache_Control_Key = "Cache-Control"
        static let Cache_Control_Value = "no-cache"
    }
}
