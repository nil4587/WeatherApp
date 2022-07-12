//
//  WeatherServicesBoundary.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

typealias CurrentWeatherResponseBlock = (_ error: String?,
                                         _ responseModel: CurrentWeatherResponseModel?) -> Void
typealias WeatherForecastResponseBlock = (_ error: String?,
                                         _ responseModel: WeatherForecastResponseModel?) -> Void

protocol WeatherServicesBoundary: BaseServiceBoundary {
    func fetchCurrentWeatherInformation(using latitude: Double,
                                        longitude: Double,
                                        success: @escaping CurrentWeatherResponseBlock,
                                        failure: @escaping BoundaryFailureBlock)
    
    func fetchWeatherForecast(using latitude: Double,
                              longitude: Double,
                              success: @escaping WeatherForecastResponseBlock,
                              failure: @escaping BoundaryFailureBlock)
}
