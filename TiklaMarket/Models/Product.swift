//
//  Prod.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 17.08.2023.
//
import Foundation

struct Product:Codable {
    var name: String        = ""
    var id : String         = ""
    var imageURL: String?   = ""
    var pay : String?       = ""
    var subject : String?   = ""
    
    //in bag
    var count:Int? = 0

    init(name: String, id: String, imageURL: String, pay: String, subject: String) {
        self.name = name
        self.id = id
        self.imageURL = imageURL
        self.pay = pay
        self.subject = subject
        self.count = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        self.pay = try container.decodeIfPresent(String.self, forKey: .pay)
        self.subject = try container.decodeIfPresent(String.self, forKey: .subject) ?? ""
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
    }
    
    func getAllData() -> [String : Any]{
        return [
            "count" : count,
            "name":name,
            "id" : id,
            "pay":pay,
            "imageURL": imageURL
        ]
        
    }
}
