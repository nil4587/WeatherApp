//
//  UIViewController+Extensions.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 12/07/22.
//

import Foundation
import UIKit

// MARK: - ================================
// MARK: System default alert with message & title
// MARK: ================================

extension UIViewController {
    
    /// A function to display an AlertView with appropriate title & message text
    func displayAlert(_ title: String? = AppConstants.AppInfo.applicationTitle,
                      message: String, completion:((_ index: Int) -> Void)?, otherTitles: String? ...) {
        
        if message.trimmedString == "" {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if !otherTitles.isEmpty {
            // Create multiple buttons on Alertview as per given the list of titles
            for (i, title) in otherTitles.enumerated() {
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
                    if (completion != nil) {
                        completion!(i)
                    }
                }))
            }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                if (completion != nil) {
                    completion!(0)
                }
            }))
        }
        
        DispatchQueue.main.async {
            // Placed baseview just to handler orientation situation as per project's need
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // A method to display an alert with title
    func displayAlert(_ title: String? = AppConstants.AppInfo.applicationTitle , message: String) {
        displayAlert(title, message: message, completion: nil)
    }
    
    public func dismissMe(animated: Bool, completion: (()->())? = nil) {
        DispatchQueue.main.async {
            if let navigationStackCount = self.navigationController?.viewControllers.count, navigationStackCount > 1 {
                self.navigationController?.popViewController(animated: animated)
                completion?()
            } else {
                self.dismiss(animated: animated, completion: completion)
            }
        }
    }
}
