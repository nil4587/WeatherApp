//
//  WeatherServicesInteractor.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

class WeatherServicesInteractor: WeatherServicesBoundary {
    
    func fetchCurrentWeatherInformation(using latitude: Double,
                                        longitude: Double,
                                        success: @escaping CurrentWeatherResponseBlock,
                                        failure: @escaping BoundaryFailureBlock) {
        
        let urlString = String(format: Configurations.API.CURRENT_WEATHER_API, latitude, longitude, Configurations.Keys.WeatherAPIKey)

        let resource = Resource<CurrentWeatherResponseModel>(url: URL(string: urlString)!,
                                                                        method: .get,
                                                                        body: nil) { data in
            return CurrentWeatherResponseModel.decode(data)
        }
        
        WebServiceManager.webServiceHelper.fetchData(resource: resource) { status, errorMessage, response in
            if status == true && response != nil {
                success(nil, response)
            } else {
                guard let errorMessage = errorMessage else {
                    failure("Something went wrong")
                    return
                }
                failure(errorMessage)
            }
        }
    }
    
    func fetchWeatherForecast(using latitude: Double,
                              longitude: Double,
                              success: @escaping WeatherForecastResponseBlock,
                              failure: @escaping BoundaryFailureBlock) {

        let urlString = String(format: Configurations.API.FORECAST_API, latitude, longitude, Configurations.Keys.WeatherAPIKey)

        let resource = Resource<WeatherForecastResponseModel>(url: URL(string: urlString)!,
                                                             method: .post,
                                                             body: nil) { data in
            return WeatherForecastResponseModel.decode(data)
        }
        
        WebServiceManager.webServiceHelper.fetchData(resource: resource) { status, errorMessage, response in
            if status == true && response != nil {
                success(nil, response)
            } else {
                guard let errorMessage = errorMessage else {
                    failure("Something went wrong")
                    return
                }
                failure(errorMessage)
            }
        }
    }
}
