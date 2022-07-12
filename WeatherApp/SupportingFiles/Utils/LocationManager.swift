//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 300 //meters
        locationManager?.activityType = .other
        locationManager?.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeInActive),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    func requestForLocation() {
        locationManager?.requestLocation()
    }
    
    @objc private func appDidBecomeActive() {
        // do your stuff
        print("appDidBecomeActive")
        requestForLocation()
    }
    
    @objc private func appDidBecomeInActive() {
        // do your stuff
        print("appDidBecomeInActive")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentLocationUpdate"), object: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Constants.AppInfo.appRootViewController?.displayAlert(message: error.localizedDescription)
        currentLocation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                locationManager?.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager?.startUpdatingLocation()
                break
            case .restricted:
                UIAlertController.displayGenericPermissionAlert(title: AppConstants.AppInfo.applicationTitle,
                                                                message: "Restricted by e.g. parental controls. User can't enable Location Services")
                break
            case .denied:
                UIAlertController.displayGenericPermissionAlert(title: AppConstants.AppInfo.applicationTitle,
                                                                message: "User denied your app access to Location Services, but can grant access from Settings.app")
                break
            default:
                break
        }
    }
}
