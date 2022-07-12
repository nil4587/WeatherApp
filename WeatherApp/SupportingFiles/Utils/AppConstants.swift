//
//  AppConstants.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation
import UIKit

struct AppConstants {
    
    // MARK: - ================================
    // MARK: Appliation Informations
    // MARK: ================================
    
    struct AppInfo {
        
        /// A parameter which returns Application Title
        static var applicationTitle: String {
            if let infoDict = Bundle.main.infoDictionary, let title = infoDict["CFBundleDisplayName"] as? String {
                return title
            } else {
                return "Weather App"
            }
        }
        
        /// A parameter which returns Application version
        static var appVersion: String {
            if let infoDict = Bundle.main.infoDictionary, let version = infoDict["CFBundleShortVersionString"] as? String {
                return version
            } else {
                return "1.0"
            }
        }
        
        /// A parameter which returns Build version
        static var buildVersion: String {
            if let infoDict = Bundle.main.infoDictionary, let version = infoDict["CFBundleVersion"] as? String {
                return version
            } else {
                return "1.0"
            }
        }
        
        /// A parameter which returns Application Delegate
        static var appDelegate: AppDelegate? {
            return UIApplication.shared.delegate as? AppDelegate
        }
        
        /// A parameter which returns Scene Delegate
        static var sceneDelegate: SceneDelegate? {
            return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        }
        
        /// A parameter which returns application rootview contorller
        static var appRootViewController: UIViewController? {
            return UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).flatMap({$0.windows}).first?.rootViewController
        }
        
        /// A parameter which returns application rootview contorller
        static var window: UIWindow? {
            return UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).flatMap({$0.windows}).filter({$0.isKeyWindow == true}).first
        }
    }
    
    // MARK: - ================================
    // MARK: Colors
    // MARK: ================================
    
    enum MainColor {
        case white
        case black
        case label
        case sunny
        case rainy
        case cloudy
        
        var rawValue: UIColor {
            switch self {
                case .white:
                    return UIColor.white
                case .black:
                    return UIColor.black
                case .label:
                    return UIColor.label
                case .sunny:
                    return UIColor(named: "sunny")!
                case .rainy:
                    return UIColor(named: "rainy")!
                case .cloudy:
                    return UIColor(named: "cloudy")!
            }
        }
    }
    
}
