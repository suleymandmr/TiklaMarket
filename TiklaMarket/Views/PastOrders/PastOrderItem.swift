//
//  PastOrderItem.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 26.09.2023.
//

import Foundation
class PastOrderItem {
    var pastOrderTitle: String
    var pastOrderSubject: String
    var PastOrderImageURL: String
    
    init(pastOrderTitle: String, pastOrderSubject: String, PastOrderImageURL: String) {
        self.pastOrderTitle = pastOrderTitle
        self.pastOrderSubject = pastOrderSubject
        self.PastOrderImageURL = PastOrderImageURL
    }
}
