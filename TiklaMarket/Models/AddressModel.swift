//
//  Addresss.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 11.09.2023.
//

import Foundation
import CoreLocation

class AddressModel:Codable{
    static var shared = AddressModel()
    var adressId                          = ""
    var type                              = AddressType.home.rawValue
    var latitude:CLLocationDegrees        = 0
    var longitude:CLLocationDegrees       = 0
    var title                             = ""
    var description                       = ""
    var buildingNumber                    = ""
    var apartmentNumber                   = ""
    var floor                             = ""
    var district                          = ""
    
    func getAllData() -> Array<Any>{
        return []
    }
}

extension AddressModel{
    var toDictionnary: [String : Any]? {
          guard let data =  try? JSONEncoder().encode(self) else {
              return nil
          }
          return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
      }
}
