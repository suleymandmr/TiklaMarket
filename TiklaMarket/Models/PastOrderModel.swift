import Foundation

class PastOrderModel: Codable {
    var not: String?
    var siparisTarihi: String?
    var tur: String?
    var ucret: Double?
    var order: [Product]?

    init(not: String? = nil, siparisTarihi: String? = nil, tur: String? = nil, ucret: Double? = nil, order: [Product]? = nil) {
        self.not = not
        self.siparisTarihi = siparisTarihi
        self.tur = tur
        self.ucret = ucret
        self.order = order
    }
   
    func clear() {
        not = nil
        siparisTarihi = nil
        tur = nil
        ucret = nil
        order = nil
    }
  
    func getTotalPrice() -> Double {
        var totalPrice = 0.0
        if let order = order {
            for product in order {
                if let pay = product.pay, let count = product.count {
                    totalPrice += (Double(pay) ?? 0) * Double(count)
                }
            }
        }
        return totalPrice
    }

    func getAllData() -> [String: Any] {
        return [
            "not": not ?? "",
            "siparisTarihi": siparisTarihi ?? "",
            "tur": tur ?? "",
            "ucret": ucret ?? 0.0,
            "order": order?.map { $0.getAllData() } ?? []
        ]
    }
}
