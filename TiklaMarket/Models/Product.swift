//
//  Prod.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 17.08.2023.
//

import Foundation

struct Product:Codable {
    var name: String
    var id : String
    var imageURL: String
    var pay : String?
    var subject : String
    
    //in bag
    var count:Int? = 0
    
    func getAllData() -> [String : Any]{
        return [
            "count" : count,
            "name":name,
            "id" : id,
            "pay":pay
        ]
        
    }
}
