import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class BagsVC: UIViewController {
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var shoppingCartItems = [ShoppingCartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        // TotalPrice'i hesapla ve ekranda göster
        updateTotalPriceLabel()
    }
    
    @IBAction func confirmCartClicked(_ sender: Any) {
        // Firebase veritabanı referansını alın
           let ref = Database.database().reference()
           
           // UserModel'den totalPrice'i alın
           let totalPrice = UserModel.shared.details.bags?.totalPrice ?? 0.0
           
           // Firebase veritabanındaki totalPrice'i güncelleyin
           let userRef = ref.child("Users/\(UserModel.shared.uid)/bags/totalPrice")
           userRef.setValue(totalPrice) { error, _ in
               if let error = error {
                   print("TotalPrice güncellenirken hata oluştu: \(error.localizedDescription)")
               } else {
                   print("TotalPrice başarıyla güncellendi.")
               }
           }
           
           // Sepette ürün varsa ödeme ekranına geçiş yapın
           if UserModel.shared.details.bags?.products.isEmpty == false {
               if let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC {
                   self.navigationController?.pushViewController(paymentViewController, animated: true)
               }
           }
       }
    
    @IBAction func allDeleteClicked(_ sender: Any) {
        UserModel.shared.details.bags?.products = []
           UserModel.shared.details.bags?.totalPrice = 0
           self.feeLabel.text = "0"

           // UserDefaults'tan kullanıcı verilerini temizle
           UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userData.rawValue)

           // Firebase veritabanındaki sepet verilerini sil
           let ref = Database.database().reference()
           let userRef = ref.child("Users/\(UserModel.shared.uid)/bags")

           // Kullanıcının altındaki tüm verileri sil
           userRef.removeValue { error, _ in
               if let error = error {
                   print("Verileri silme hatası: \(error.localizedDescription)")
               } else {
                   print("Tüm veriler başarıyla silindi.")
               }
           }

           // TableView'ı yeniden yükle
           self.tableView.reloadData()
       }
    
    func updateTotalPriceLabel() {
        var totalPrice = 0.0
        
        for product in UserModel.shared.details.bags!.products {
            if let payString = product.pay, let countString = product.count,
               let productPrice = Double(payString), let productCount = Double(exactly: countString) {
                totalPrice += productPrice * productCount
            } else {
                // Dönüşüm başarısız oldu, uygun bir hata yönetimi ekleyebilirsiniz
                print("Dönüşüm başarısız oldu.")
            }
        }
        
        UserModel.shared.details.bags?.totalPrice = totalPrice
        feeLabel.text = "\(totalPrice)"
    }
}

extension BagsVC: UITableViewDelegate, UITableViewDataSource {
    
   
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                  // Ürünü listeden kaldır
                  UserModel.shared.details.bags!.products.remove(at: indexPath.row)
                  
                  // TotalPrice'i güncelle
                  updateTotalPriceLabel()
                  
                  // UserDefaults veya Firebase gibi bir veritabanına güncel totalPrice'i kaydet
                  do {
                      let encoder = JSONEncoder()
                      let user = try encoder.encode(UserModel.shared)
                      UserDefaults.standard.set(user, forKey: UserDefaultsKeys.userData.rawValue)
                      let arr = UserModel.shared.details.bags!.products.map({ $0.getAllData() })
                      let ref = Database.database().reference()
                      let userRef = ref.child("Users/"+UserModel.shared.uid+"/bags/products/")
                      userRef.setValue(arr)
                  } catch {
                      print("Verileri kaydederken hata oluştu.")
                  }
                  
                  // TableView'ı yeniden yükle
                  tableView.deleteRows(at: [indexPath], with: .fade)
              }
          }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModel.shared.details.bags?.products.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BagsCell
        cell.productNameLabel.text = UserModel.shared.details.bags!.products[indexPath.row].name
        cell.productFeeLabel.text = "\(UserModel.shared.details.bags!.products[indexPath.row].count!) adet"
        cell.payLabel.text = "bf:\(UserModel.shared.details.bags!.products[indexPath.row].pay!)"
        cell.productImageView.sd_setImage(with: URL(string: UserModel.shared.details.bags!.products[indexPath.row].imageURL ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
