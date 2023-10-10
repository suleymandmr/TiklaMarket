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
        
        feeLabel.text = "\(UserModel.shared.details.bags!.totalPrice)"
    }

    @IBAction func confirmCartClicked(_ sender: Any) {
        if let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC {
               // PaymentVC'yi göster
               self.navigationController?.pushViewController(paymentViewController, animated: true)
           }
    }
    
    @IBAction func allDeleteClicked(_ sender: Any) {
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
        
    }
}

extension BagsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
              // Ürünü listeden kaldır
              UserModel.shared.details.bags!.products.remove(at: indexPath.row)
              
              // TotalPrice'i sıfırla
              UserModel.shared.details.bags!.totalPrice = 0
              
              // Kalan ürünlerin fiyatlarını topla ve totalPrice'i güncelle
              for product in UserModel.shared.details.bags!.products {
                  if let payString = product.pay, let countString = product.count,
                     let productPrice = Int(payString), let productCount = Int(exactly: countString) {
                      // Burada productPrice ve productCount kullanabilirsiniz
                      UserModel.shared.details.bags!.totalPrice += productPrice * productCount
                  } else {
                      // Dönüşüm başarısız oldu, uygun bir hata yönetimi ekleyebilirsiniz
                      print("Dönüşüm başarısız oldu.")
                  }}
              
              // UserDefaults veya Firebase gibi bir veritabanına güncel totalPrice'i kaydet
              do {
                  let encoder = JSONEncoder()
                  let user = try encoder.encode(UserModel.shared)
                  UserDefaults.standard.set(user, forKey: UserDefaultsKeys.userData.rawValue)
                  let arr = UserModel.shared.details.bags!.products.map({ $0.getAllData() })
                  let ref = Database.database().reference()
                  let userRef = ref.child("Users/"+UserModel.shared.uid+"/bags/products/")
                  userRef.setValue(arr)
              } catch { }
              
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
