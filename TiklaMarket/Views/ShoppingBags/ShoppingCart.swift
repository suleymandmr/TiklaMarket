//
//  ShoppingCart.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 25.09.2023.
//

import Foundation
class ShoppingCart {
    static let shared = ShoppingCart()
    
    var items: [Product] = [] // Sepetteki ürünleri temsil eden bir dizi
    
    func addItem(_ product: Product) {
        items.append(product)
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    // Sepet toplamını hesaplayan bir işlev
    func calculateTotal() -> Double {
        var total: Double = 0.0
        
        for item in items {
            if let payString = item.pay,
               let payDouble = Double(payString) {
                total += payDouble
            }
        }
        
        return total
    }

}
