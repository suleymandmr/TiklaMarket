//
//  User.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 11.09.2023.
//

import Foundation

class UserModel:Codable{
    static var shared = UserModel()
    
    var uid              = ""
    var email            = ""
    var nameSurname      = ""
    var phoneNumber      = ""
    var phoneCountryCode = ""
    var address: [AddressModel] = []
    
}
