//
//  WeatherHomeViewModel.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherHomeViewModelDelegate: NSObjectProtocol {
    func currentWeatherInformationFetchedSuccessfully()
    func currentWeatherInformationFailure()
    func weatherForecasInformationFetchedSuccessfully()
    func weatherForecasInformationFailure()
}

class WeatherHomeViewModel {
    
    private weak var delegate: WeatherHomeViewModelDelegate?
    private var interactor: WeatherServicesBoundary?
    private var currentLocation: CLLocation?
    private var currentWeatherReponseModel: CurrentWeatherResponseModel?
    private var forecastWeatherResponseModel: WeatherForecastResponseModel?
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Initialisation
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    init(delegate: WeatherHomeViewModelDelegate?,
         interactor: WeatherServicesBoundary?) {
        self.delegate = delegate
        self.interactor = interactor
    }

    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Getters
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    var isCurrentLocationAvailable: Bool {currentLocation != nil}
    private var latitude: Double { currentLocation?.coordinate.latitude ?? 0.0000 }
    private var longitude: Double { currentLocation?.coordinate.longitude ?? 0.0000 }
    var currentTemprature: String? {
        guard let currentTemprature = currentWeatherReponseModel?.main?.temp else {return nil}
        return String(format: "%.f˚", currentTemprature.toCelcius())
    }
    var minimumTemprature: String?  {
        guard let minimumTemprature = currentWeatherReponseModel?.main?.tempMin else {return nil}
        return String(format: "%.f˚", minimumTemprature.toCelcius())
    }
    var maximumTemprature: String?  {
        guard let maximumTemprature = currentWeatherReponseModel?.main?.tempMax else {return nil}
        return String(format: "%.f˚", maximumTemprature.toCelcius())
    }
    var weatherBackgroundImage: UIImage? {
        guard let weather = currentWeatherReponseModel?.weather?.first else { return nil }
        return weather.main?.backgroundImage
    }
    var backgroundColor: UIColor? {
        guard let weather = currentWeatherReponseModel?.weather?.first else { return .systemBackground }
        return weather.main?.color
    }
    var weatherType: String? {
        guard let weather = currentWeatherReponseModel?.weather?.first else { return nil }
        return weather.main?.name
    }
    var forecastItems: Int { forecastWeatherResponseModel?.list?.count ?? 0 }
    
    func weatherDetails(at index: Int) -> (day: String?, icon: UIImage?, temp: String?) {
        guard let listObj = forecastWeatherResponseModel?.list?[index] else { return (nil, nil, nil) }
        let day = listObj.dateString?.toString()
        let icon = listObj.weather?.first?.main?.icon
        let temp = String(format: "%.f˚", listObj.weatherDetails?.temp?.toCelcius() ?? 0.0)
        return (day, icon, temp)
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Setters
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    func set(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Web-Services call
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    func fetchCurrentWeatherInformation() {
        interactor?.fetchCurrentWeatherInformation(using: latitude,
                                                   longitude: longitude,
                                                   success: {[weak self] error, responseModel in
            self?.currentWeatherReponseModel = responseModel
            self?.delegate?.currentWeatherInformationFetchedSuccessfully()
        },
                                                   failure: {[weak self] error in
            self?.currentWeatherReponseModel = nil
            self?.delegate?.currentWeatherInformationFailure()
        })
    }
    
    func fetchWeatherForecast() {
        interactor?.fetchWeatherForecast(using: latitude,
                                         longitude: longitude,
                                         success: {[weak self] error, responseModel in
            self?.forecastWeatherResponseModel = responseModel
            self?.delegate?.weatherForecasInformationFetchedSuccessfully()
        },
                                         failure: {[weak self] error in
            self?.forecastWeatherResponseModel = nil
            self?.delegate?.weatherForecasInformationFailure()
        })
    }
}
