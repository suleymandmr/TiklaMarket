//
//  Main.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 15.08.2023.
//

import Foundation
class Category {
    var id: Int
    var baslik: String
    var resimAdi: String
    
    init(id: Int, baslik: String, resimAdi: String) {
        self.id = id
        self.baslik = baslik
        self.resimAdi = resimAdi
    }
}
