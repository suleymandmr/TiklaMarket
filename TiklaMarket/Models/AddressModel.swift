//
//  Addresss.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 11.09.2023.
//

import Foundation
import CoreLocation

class AddressModel:Codable{
    
    var type                              = AddressType.home.rawValue
    var latitude:CLLocationDegrees        = 0
    var longitude:CLLocationDegrees       = 0
    var title                             = ""
    var description                       = ""
    var buildingNumber                    = ""
    var apartmentNumber                   = ""
    var floor                             = ""
    var district                          = ""
    
    func getAllData() -> [String: Any]{
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
