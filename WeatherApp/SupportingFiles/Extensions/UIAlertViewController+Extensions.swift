//
//  UIAlertViewController+Extensions.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 12/07/22.
//

import Foundation
import UIKit

enum PermissionsType {
    case generalsettings
    case location
}

extension UIAlertController {
    
    static func displayGenericPermissionAlert(title: String = AppConstants.AppInfo.applicationTitle, message: String) {
        var otherActionTitle = ""
        var otherActionUrl: URL!
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        otherActionUrl = URL(string: UIApplication.openSettingsURLString)!
        otherActionTitle = "AlertSettingsTitle".localised()

        // Cancel action
        let cancelAction = UIAlertAction(title: "AlertCancelTitle".localised(), style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        // Other action
        let otherAction = UIAlertAction(title: otherActionTitle, style: .default, handler: { action in
            UIApplication.shared.open(otherActionUrl, options: [:], completionHandler: nil)
        })
        controller.addAction(otherAction)
        AppConstants.AppInfo.appRootViewController?.present(controller, animated: true, completion: nil)
    }
    
    static func displayAlert(for title: String = AppConstants.AppInfo.applicationTitle, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "AlertOkTitle".localised(), style: .default, handler: nil)
        controller.addAction(otherAction)
        AppConstants.AppInfo.appRootViewController?.present(controller, animated: true, completion: nil)
    }
}
