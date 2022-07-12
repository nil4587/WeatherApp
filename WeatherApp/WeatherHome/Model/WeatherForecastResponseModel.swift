//
//  WeatherForecastResponseModel.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

struct WeatherForecastResponseModel {
    private(set) var cod: String?
    private(set) var message, count: Int?
    private(set) var list: [List]?
    private(set) var city: City?
    
    enum CodingsKey: String, CodingKey {
        case cod, message
        case count = "cnt"
        case list, city
    }
}

extension WeatherForecastResponseModel: Decodable {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingsKey.self)
            cod = try container.decodeIfPresent(String.self, forKey: .cod)
            message = try container.decodeIfPresent(Int.self, forKey: .message)
            count = try container.decodeIfPresent(Int.self, forKey: .count)
            list = try container.decodeIfPresent([List].self, forKey: .list)
            city = try container.decodeIfPresent(City.self, forKey: .city)
            
            //Filtering the original list by removing multiple instances of the same day
            var tempfilteredList = [List]()
            let today = Date().description.components(separatedBy: " ").first
            list?.forEach({ listObj in
                if tempfilteredList.filter({$0.formattedDateString == listObj.formattedDateString}).count == 0, listObj.formattedDateString != nil, listObj.formattedDateString != today {
                    tempfilteredList.append(listObj)
                }
            })
            list = tempfilteredList
        } catch {
            print("WeatherForecastResponseModel : \(error.localizedDescription)")
        }
    }
}

// MARK: - City
struct City: Decodable {
    private(set) var id: Int?
    private(set) var name: String?
    private(set) var coord: Coordinate?
    private(set) var country: String?
    private(set) var population, timezone, sunrise, sunset: Int?
}

// MARK: - List
struct List {
    private(set) var dateInterval: Int?
    private(set) var weatherDetails: WeatherDetails?
    private(set) var weather: [Weather]?
    private(set) var clouds: Clouds?
    private(set) var wind: Wind?
    private(set) var visibility: Int?
    private(set) var dateString: String?
    private(set) var formattedDateString: String?
    
    enum CodingsKey: String, CodingKey {
        case dateInterval = "dt"
        case weatherDetails = "main"
        case weather, clouds, wind
        case visibility
        case dateString = "dt_txt"
    }
}

extension List: Decodable {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingsKey.self)
            dateInterval = try container.decodeIfPresent(Int.self, forKey: .dateInterval)
            weatherDetails = try container.decodeIfPresent(WeatherDetails.self, forKey: .weatherDetails)
            weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
            clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
            wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
            visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
            dateString = try container.decodeIfPresent(String.self, forKey: .dateString)
            guard let dateString = dateString else { return }
            formattedDateString = dateString.components(separatedBy: " ").first
        } catch {
            print("List : \(error.localizedDescription)")
        }
    }
}

// MARK: - MainClass
struct WeatherDetails: Decodable {
    private(set) var temp, feelsLike, tempMin, tempMax: Float?
    private(set) var pressure, seaLevel, groundLevel, humidity: Int?
    private(set) var tempKf: Float?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case tempKf = "temp_kf"
        case groundLevel = "grnd_level"
        case seaLevel = "sea_level"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}
