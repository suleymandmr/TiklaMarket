//
//  PastProductItem.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.09.2023.
//

import Foundation
class PastProductItem {
    var pastProductPay: String
    var pastProductNote: String
    var PastProductDate: String
    
    init(pastProductPay: String, pastProductNote: String, PastProductDate: String) {
        self.pastProductPay = pastProductPay
        self.pastProductNote = pastProductNote
        self.PastProductDate = PastProductDate
    }
}
