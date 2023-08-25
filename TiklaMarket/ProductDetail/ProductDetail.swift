//
//  ProductDetail.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 23.08.2023.
//

import Foundation

    class ProductDetail {
        var id: Int
        var productName: String
        var productImageURL: String
        var productPay : String
        
        init(id: Int, productName: String, productImageURL: String, productPay: String) {
            self.id = id
            self.productName = productName
            self.productImageURL = productImageURL
            self.productPay = productPay
        }
    

}
