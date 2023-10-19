import UIKit
import Firebase
import FirebaseDatabase

enum PaymentType: String {
    case Cash
    case CreditCard
}

class PaymentVC: UIViewController {
    
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var cashButton: UIButton!
    
    var selectedProduct: Product?
    var paymentType: PaymentType = .Cash
    var payArray = [String]()
    var feeArray = [String]()
    
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var notLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTotalPriceLabel()
        initializeHideKeyboard()
        
        // Başlangıçta bir butonun seçili olduğunu belirtin (örneğin, "Kredi Kartı" butonu)
        creditCardButton.isSelected = true
        cashButton.isSelected = false
        
        // Butonlara tıklanma olaylarını ekleyin
        creditCardButton.addTarget(self, action: #selector(creditCardClicked), for: .touchUpInside)
        cashButton.addTarget(self, action: #selector(cashClicked), for: .touchUpInside)
        
        // Butonların başlangıç rengini ayarlayın
        configureButton(creditCardButton)
        configureButton(cashButton)
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
        
        payLabel.text = "\(totalPrice) tl"
    }
    
    func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" // Tarih ve saat biçimini ayarlayın
        let currentDateTime = Date()
        return dateFormatter.string(from: currentDateTime)
    }
    
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = UIColor.blue // Sabit mavi renk
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func creditCardClicked(_ sender: UIButton) {
        paymentType = .CreditCard
        UserModel.shared.details.pastOrders?.tur = "CreditCard"
        paymentTypeLabel.text = "Kredi Kartı"
    }

    @IBAction func cashClicked(_ sender: UIButton) {
        paymentType = .Cash
        UserModel.shared.details.pastOrders?.tur = "Cash"
        paymentTypeLabel.text = "Nakit"
    }

    @IBAction func cancelClicked(_ sender: Any) {
        // Kullanıcı "Vazgeç" butonuna bastığında hiçbir şey yapma, yalnızca alerti kapat
        dismiss(animated: true, completion: nil)
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
            UserModel.shared.details.pastOrders?.not = note
        }

        // Geçerli tarih ve saati al
        let currentDateTime = getCurrentDateTime()

        // Tarih ve saat bilgisini PastOrderModel'e ekleyin
        UserModel.shared.details.pastOrders?.siparisTarihi = currentDateTime

        // PastOrderModel'i Firebase'e kaydet
        savePastOrderToFirebase()

        // Ödeme onayı için alerti göster ve Firebase'e kayıt yapılmasını sağla
        displayAlert()
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

    func displayAlert() {
        let alertController = UIAlertController(title: "Ödeme Onaylandı", message: "İşleminiz alındı en kısa zamanda size ulaşaktır.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            self.navigateToMainPage()
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    func navigateToMainPage() {
        
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainVC {
            navigationController?.pushViewController(mainVC, animated: true)
        }
    }
   
}

extension PaymentVC {

    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
