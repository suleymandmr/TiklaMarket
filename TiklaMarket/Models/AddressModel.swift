//
//  Addresss.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 11.09.2023.
//

import Foundation
import CoreLocation

class AddressModel:Codable{
    
    var type                              = AddressTypes.home.rawValue
    var latitude                          = 0.0
    var longitude                         = 0.0
    var title                             = ""
    var description                       = ""
    var buildingNumber                    = ""
    var apartmentNumber                   = ""
    var floor                             = ""
    var district                          = ""
    
    func getAllData() -> [String: Any]{
        //tek değeri push etmek için (test edilmedi)
        return  [
            "type": type,
            "latitude": latitude,
            "longitude": longitude,
            "title": title,
            "description": description,
            "buildingNumber": buildingNumber,
            "apartmentNumber": apartmentNumber,
            "floor": floor,
            "district": district
        ]
    }
}

