//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

extension String {
    var trimmedString: String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: CharacterSet.punctuationCharacters) }
    
    func localised() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func boolValue() -> Bool {
        return self.lowercased() == "true" ? true : false
    }
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        guard let date = formatter.date(from: self) else {return nil}
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
