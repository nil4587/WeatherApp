//
//  LocationsViewModel.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 11/07/22.
//

import Foundation

protocol LocationsViewModelDelegate: NSObjectProtocol {
    func locationsRetrivedSuccessfully()
    func locationsRetrivalFailed()
}

class LocationsViewModel {
    
    private weak var delegate: LocationsViewModelDelegate?
    private var interactor: LocationServicesBoundary?
    private var locations: [LocationModel]?
    var isSearching: Bool = false

    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Initialisation
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    init(delegate: LocationsViewModelDelegate?,
         interactor: LocationServicesBoundary?) {
        self.delegate = delegate
        self.interactor = interactor
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Getters
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    var numberOfItems: Int {
        return isSearching ? locations?.count ?? 0 : savedLocations?.count ?? 0
    }
    
    private var savedLocations: [LocationModel]? {
        return AppConstants.AppInfo.appDelegate?.fetchLocationData()
    }
    
    func locationDetails(at index: Int) -> (title: String?, subTitle: String?)? {
        if isSearching {
            guard let location = locations?[index] else {return nil}
            return (location.title, location.subTitle)
        } else {
            guard let location = savedLocations?[index] else {return nil}
            return (location.title, location.subTitle)
        }
    }
    
    func saveLocationAt(index: Int) -> (latitude: Double?, longitude: Double?)? {
        guard let location = locations?[index] else {return nil}
        AppConstants.AppInfo.appDelegate?.save(location: location)
        return (location.lat, location.lon)
    }
    
    func locationAt(index: Int) -> (latitude: Double?, longitude: Double?)? {
        guard let location = savedLocations?[index] else {return nil}
        return (location.lat, location.lon)
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: User-defined methods
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    func clearSearchResult() {
        locations?.removeAll()
        locations = nil
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Webserivces call
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    func fetchLocation(using searchText: String) {
        interactor?.getLocation(using: searchText,
                                success: { error, responseModel in
            self.locations = responseModel?.locations
            self.delegate?.locationsRetrivedSuccessfully()
        }, failure: { error in
            self.delegate?.locationsRetrivalFailed()
        })
    }
    
    deinit {
        interactor = nil
        locations?.removeAll()
        locations = nil
    }
}
