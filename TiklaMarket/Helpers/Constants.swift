//
//  Constants.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 12.09.2023.
//

import Foundation

enum UserDefaultsKeys:String{
    case isLoggedIn
    case userData
}

enum KeyChainKeys:String{
    case password
}

enum AddressTypes:String{
    case home
    case office
}

enum AddressImages:String{
    case home = "https://cdn0.iconfinder.com/data/icons/business-1390/24/20_-_Company-2-512.png"
    case office = "https://cdn0.iconfinder.com/data/icons/expenses-vs-income/30/__house_home_flat_facilities-512.png"
}
