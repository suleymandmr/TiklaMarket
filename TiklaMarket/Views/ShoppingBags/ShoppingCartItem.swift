//
//  ShoppingCartItem.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 25.09.2023.
//

import Foundation
class ShoppingCartItem {
    var productName: String
    var productFee: String
    var productImageURL: String
    
    init(productName: String, productFee: String, productImageURL: String) {
        self.productName = productName
        self.productFee = productFee
        self.productImageURL = productImageURL
    }
}
