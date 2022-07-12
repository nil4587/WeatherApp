//
//  Fonts+Extensions.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation
import UIKit

typealias MainFont = Font.Roboto

enum Font {
    enum Roboto: String {
        case medium = "Medium"
        case light = "Light"
        case regular = "Regular"
        case mediumItalic = "MediumItalic"
        case thinItalic = "ThinItalic"
        case boldItalic = "BoldItalic"
        case lightItalic = "LightItalic"
        case italic = "Italic"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case thin = "Thin"
        case black = "Black"
        
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-\(rawValue)", size: size)!
        }
    }
}

extension UIFont {
    static func font(with font: UIFont?, and textStyle: UIFont.TextStyle) -> UIFont {
        guard let font = font else {
            fatalError("Can't find the custom font")
        }
        return font
    }
}
