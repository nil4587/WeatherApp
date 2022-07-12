//
//  LocationServicesResponseModel.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 12/07/22.
//

import Foundation

struct LocationServicesResponseModel {
    private(set) var locations: [LocationModel]?
}

extension LocationServicesResponseModel: Decodable {
    static func returnModelUsing(_ data: Data) -> LocationServicesResponseModel? {
        do {
            let locationsList = try JSONDecoder().decode([LocationModel].self, from: data)
            let responseModel = LocationServicesResponseModel(locations: locationsList)
            return responseModel
        } catch {
            #if DEBUG
                print(error.localizedDescription)
            #endif
            return nil
        }
    }
}
