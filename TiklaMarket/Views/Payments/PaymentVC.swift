import UIKit
import Firebase
import FirebaseDatabase

enum PaymentType: String {
    case Cash
    case CreditCard
}

class PaymentVC: UIViewController {
    
    var selectedProduct: Product?
    var paymentType: PaymentType = .Cash
    var payArray = [String]()
    var feeArray = [String]()
    
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var notLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTotalPriceLabel()
    }
    
    func updateTotalPriceLabel() {
        var totalPrice = 0.0
        
        if let bags = UserModel.shared.details.bags, !bags.products.isEmpty {
            for product in bags.products {
                if let payString = product.pay, let count = product.count {
                    if let productPrice = Double(payString) {
                        totalPrice += productPrice * Double(count)
                    }
                }
            }
        }
        
        payLabel.text = "\(totalPrice)"
    }
    
    func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" // Tarih ve saat biçimini ayarlayın
        let currentDateTime = Date()
        return dateFormatter.string(from: currentDateTime)
    }
    
    @IBAction func creditCardClicked(_ sender: Any) {
        paymentType = .CreditCard
        UserModel.shared.details.pastOrders?.tur = "CreditCard" // Kredi kartı ödeme türü
    }
    
    @IBAction func cashClicked(_ sender: Any) {
        paymentType = .Cash
        UserModel.shared.details.pastOrders?.tur = "Cash" // Nakit ödeme türü
    }
    
    @IBAction func confirmCartClicked(_ sender: Any) {
        guard let bags = UserModel.shared.details.bags, !bags.products.isEmpty else {
            return
        }
        
        if UserModel.shared.details.pastOrders == nil {
            UserModel.shared.details.pastOrders = PastOrderModel()
        }
        
        // Sepetteki ürünleri PastOrderModel'e ekle
        if var pastOrderProducts = UserModel.shared.details.pastOrders?.order {
            pastOrderProducts.append(contentsOf: bags.products)
            UserModel.shared.details.pastOrders?.order = pastOrderProducts
        } else {
            UserModel.shared.details.pastOrders?.order = bags.products
        }
        
        if UserModel.shared.details.pastOrders == nil {
            UserModel.shared.details.pastOrders = PastOrderModel()
        }

        UserModel.shared.details.pastOrders?.ucret = bags.totalPrice

        // Sepeti temizle
        clearCart()

        // Notu al ve notLabel'a yazdır
        if let note = noteText.text {
            UserModel.shared.details.pastOrders?.not = note        }

        // Geçerli tarih ve saati al
        let currentDateTime = getCurrentDateTime()

        // Tarih ve saat bilgisini PastOrderModel'e ekleyin
        UserModel.shared.details.pastOrders?.siparisTarihi = currentDateTime

        // PastOrderModel'i Firebase'e kaydet
        savePastOrderToFirebase()

        // Ücreti sıfırlama
        updateTotalPriceLabel()
    }

    func clearCart() {
        let ref = Database.database().reference()
        let bagsRef = ref.child("Users/\(UserModel.shared.uid)/bags")
        
        bagsRef.removeValue { (error, reference) in
            if let error = error {
                print("Sepet temizleme hatası: \(error.localizedDescription)")
            } else {
                print("Sepet başarıyla temizlendi.")
            }
        }
    }
   

    func savePastOrderToFirebase() {
        if let pastOrders = UserModel.shared.details.pastOrders {
            let ref = Database.database().reference()
            let userRef = ref.child("Users/\(UserModel.shared.uid)/pastOrders/").childByAutoId()
            let data = pastOrders.getAllData()
            
            userRef.setValue(data) { (error, reference) in
                if let error = error {
                    print("Veri kaydetme hatası: \(error.localizedDescription)")
                } else {
                    print("Veri başarıyla Firebase'e kaydedildi.")
                }
            }
        }
    }
}
