//
//  Codable+Extensions.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

extension Decodable {
    
    func decode<T : Decodable>(from dictionary: [String : Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func decode<T : Decodable>(_ data: Data) -> T? {
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            return responseModel
        } catch {
        #if DEBUG
            print(self, error.localizedDescription)
        #endif
            return nil
        }
    }
}

extension Encodable {
    static func encode<T : Encodable>(_ value: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(value)
            return jsonData
        } catch {
        #if DEBUG
            print(error.localizedDescription)
        #endif
            return nil
        }
    }
    
    static func jsonData(_ data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any]
            return jsonObject
        } catch {
            return nil
        }
    }
}
