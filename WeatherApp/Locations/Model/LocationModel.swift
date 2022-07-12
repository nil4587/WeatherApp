//
//  Location.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 12/07/22.
//

import Foundation

struct LocationModel: Decodable {
    private(set) var name: String?
    private(set) var local_names: [String: String]?
    private(set) var country: String?
    private(set) var state: String?
    private(set) var lat: Double?
    private(set) var lon: Double?
    
    var title: String { String(format: "%@, %@, %@",
                               name?.trimmedString ?? "",
                               state?.trimmedString ?? "",
                               country?.trimmedString ?? "") }
    
    var subTitle: String { String(format: "lat: %f lon: %f", lat ?? 0.00, lon ?? 0.00) }
}
/*
"name": "Ahmedabad",
"local_names": {
    "hi": "अहमदाबाद",
    "ar": "أحمد آباد",
    "he": "אחמדאבאד",
    "ur": "احمد آباد",
    "eo": "Ahmadabado",
    "ru": "Ахмадабад",
    "feature_name": "Ahmedabad",
    "ml": "അഹമ്മദാബാദ്",
    "kn": "ಅಹ್ಮದಾಬಾದ್",
    "ja": "アフマダーバード",
    "en": "Ahmedabad",
    "uk": "Ахмедабад",
    "ta": "அகமதாபாத்",
    "cs": "Ahmadábád",
    "pa": "ਅਹਿਮਦਾਬਾਦ",
    "zh": "艾哈迈达巴德",
    "gu": "અમદાવાદ",
    "or": "ଅହମଦାବାଦ",
    "oc": "Ahmadabad",
    "ascii": "Ahmedabad",
    "pl": "Ahmadabad",
    "de": "Ahmedabad"
},
"lat": 23.0216238,
"lon": 72.5797068,
"country": "IN",
"state": "Gujarat"*/
