//
//  CurrentWeatherResponseModel.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation
import UIKit

enum WeatherType: String, Decodable {
    case clear = "Clear"
    case cloud = "Clouds"
    case rain = "Rain"
    case haze = "Haze"
    case drizzle = "Drizzle"
    
    var name: String {
        switch self {
            case .clear: return "SUNNY"
            case .cloud: return "CLOUDY"
            case .haze: return "HAZE"
            case .rain: return "RAINY"
            case .drizzle: return "Drizzle"
        }
    }
    
    var color: UIColor? {
        switch self {
            case .clear: return UIColor(named: "sunny")
            case .cloud: return UIColor(named: "cloudy")
            case .haze: return UIColor(named: "cloudy")
            case .rain: return UIColor(named: "rainy")
            case .drizzle: return UIColor(named: "rainy")
        }
    }
    
    var icon: UIImage? {
        switch self {
            case .clear: return UIImage(named: "clear")
            case .cloud: return UIImage(named: "partlysunny")
            case .haze: return UIImage(named: "partlysunny")
            case .rain: return UIImage(named: "rain")
            case .drizzle: return UIImage(named: "rain")
        }
    }
    
    var backgroundImage: UIImage? {
        switch self {
            case .clear: return UIImage(named: "forest_sunny")
            case .cloud: return UIImage(named: "forest_cloudy")
            case .haze: return UIImage(named: "forest_cloudy")
            case .rain: return UIImage(named: "forest_rainy")
            case .drizzle: return UIImage(named: "forest_rainy")
        }
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: CurrentWeatherResponseModel
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct CurrentWeatherResponseModel: Decodable {
    private(set) var coord: Coordinate?
    private(set) var weather: [Weather]?
    private(set) var base: String?
    private(set) var main: Main?
    private(set) var visibility: Int?
    private(set) var wind: Wind?
    private(set) var clouds: Clouds?
    private(set) var dt: Int?
    private(set) var sys: Sys?
    private(set) var timezone, id: Int?
    private(set) var name: String?
    private(set) var cod: Int?
    
    enum CodingKeys: String, CodingKey {
        case timezone, cod, name, id
        case coord, weather, base
        case main, visibility, wind
        case clouds, dt, sys
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: Clouds
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct Clouds: Decodable {
    private(set) var all: Int?
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: Coord
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct Coordinate: Decodable {
    private(set) var lat, lon: Double?
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: Main
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct Main: Decodable {
    private(set) var feelsLike: Float?
    private(set) var humidity, pressure: Float?
    private(set) var temp, tempMax, tempMin: Float?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case feelsLike = "feels_like"
        case pressure, humidity
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: Sys
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct Sys: Decodable {
    private(set) var country: String?
    private(set) var id, sunrise, sunset: Int?
    private(set) var type: Int?
    
    enum CodingKeys: String, CodingKey {
        case type, id
        case country
        case sunrise, sunset
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: Weather
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct Weather: Decodable {
    private(set) var weatherDescription, icon: String?
    private(set) var id: Int?
    private(set) var main: WeatherType?
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case id, main, icon
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: Wind
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

struct Wind: Decodable {
    private(set) var deg: Float?
    private(set) var gust, speed: Float?

    enum CodingKeys: String, CodingKey {
        case speed, deg, gust
    }
}
/*
{
    "coord": {
        "lon": 72.8562,
        "lat": 19.0176
    },
    "weather": [{
        "id": 721,
        "main": "Haze",
        "description": "haze",
        "icon": "50d"
    }],
    "base": "stations",
    "main": {
        "temp": 301.13,
        "feels_like": 306.66,
        "temp_min": 301.09,
        "temp_max": 301.13,
        "pressure": 1004,
        "humidity": 89
    },
    "visibility": 2500,
    "wind": {
        "speed": 6.69,
        "deg": 260
    },
    "clouds": {
        "all": 75
    },
    "dt": 1657632549,
    "sys": {
        "type": 1,
        "id": 9052,
        "country": "IN",
        "sunrise": 1657586285,
        "sunset": 1657633788
    },
    "timezone": 19800,
    "id": 1275339,
    "name": "Mumbai",
    "cod": 200
}
*/
