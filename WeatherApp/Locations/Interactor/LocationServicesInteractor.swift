//
//  LocationServicesInteractor.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 12/07/22.
//

import Foundation

class LocationServicesInteractor: LocationServicesBoundary {
    
    func getLocation(using searchText: String,
                     success: @escaping LocationServicesResponseBlock,
                     failure: @escaping BoundaryFailureBlock) {
        
        let urlString = String(format: Configurations.API.GEO_CODING_API, searchText, Configurations.Keys.WeatherAPIKey)
        
        let resource = Resource<LocationServicesResponseModel>(url: URL(string: urlString)!,
                                                             method: .get,
                                                             body: nil) { data in
            return LocationServicesResponseModel.returnModelUsing(data)
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
