//
//  User.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 11.09.2023.
//
import Foundation

class UserModel:Codable{
    static var shared = UserModel()
    var uid                       = ""
    var selectedAddressID         = -1
    var details:UserModelDetails  = UserModelDetails()
}

class UserModelDetails:Codable{
    var email:String               = ""
    var nameSurname:String         = ""
    var phoneNumber:String         = ""
    var phoneCountryCode:String    = ""
    var address: [AddressModel]    = []
    var bags: BagsModel?
    //var pastPays
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.nameSurname = try container.decode(String.self, forKey: .nameSurname)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.phoneCountryCode = try container.decode(String.self, forKey: .phoneCountryCode)
        self.address = try container.decodeIfPresent([AddressModel].self, forKey: .address) ?? []
        self.bags =  try container.decodeIfPresent(BagsModel.self, forKey: .bags) ?? BagsModel()
    }
    
    init(){}
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
