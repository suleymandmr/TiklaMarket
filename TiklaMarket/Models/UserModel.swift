//
//  User.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 11.09.2023.
//

import Foundation

class UserModel:Codable{
    static var shared = UserModel()
    var uid                    = ""
    var selectedAddressID      = -1
    var details:UserModelDetails  = UserModelDetails()
    var paymentDetail:UserModelPaymant = UserModelPaymant()
}

class UserModelDetails:Codable{
    var email            = ""
    var nameSurname      = ""
    var phoneNumber      = ""
    var phoneCountryCode = ""
    //var payment: [PaymantModel] = []
    var address: [AddressModel] = []
}

class UserModelPaymant:Codable{
    var email            = ""
    var nameSurname      = ""
    var phoneNumber      = ""
    var phoneCountryCode = ""
    var payment: [PaymantModel] = []
   // var address: [AddressModel] = []
}
