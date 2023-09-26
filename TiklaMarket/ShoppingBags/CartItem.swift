
import Foundation
struct CartItem {
    let productName: String // Ürün adı
    let productPrice: Double // Ürün fiyatı
    var quantity: Int // Ürün miktarı
    
    init(name: String, price: Double, quantity: Int = 1) {
        self.productName = name
        self.productPrice = price
        self.quantity = quantity
    }
}
