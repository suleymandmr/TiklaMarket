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
}

class UserModelDetails:Codable{
    var email                   = ""
    var nameSurname             = ""
    var phoneNumber             = ""
    var phoneCountryCode        = ""
    var address: [AddressModel] = []
    var bags: [BagsModel]?       = []
    //var payment: [PaymantModel] = []
    
    //var paymentDetail:UserModelPaymant = UserModelPaymant()
    //var BagsDetail:UserModeBags = UserModeBags()
    
}


/*
class UserModelPaymant:Codable{
    var email            = ""
    var nameSurname      = ""
    var phoneNumber      = ""
    var phoneCountryCode = ""
    var payment: [PaymantModel] = []
   // var address: [AddressModel] = []
}
class UserModeBags:Codable{
    var email            = ""
    var nameSurname      = ""
    var phoneNumber      = ""
    var phoneCountryCode = ""
    var bags: [BagsModel] = []
   // var address: [AddressModel] = []
}
*/
