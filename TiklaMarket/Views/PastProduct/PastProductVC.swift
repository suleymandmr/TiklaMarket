import UIKit
import Firebase

class PastProductVC: UIViewController {
    
    
    var productLists = [PastOrderModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
                tableView.dataSource = self
                tableView.delegate = self
        Task {
                    await fetchDataFromRealtimeDatabase()
                }
        
    }
    override func viewDidAppear(_ animated: Bool) {
           Task {
               await fetchDataFromRealtimeDatabase()
           }
       }
    func fetchDataFromRealtimeDatabase() async {
        let data = await Api().getPastOrders()
        self.productLists = data ?? []
        self.tableView.reloadData()
    }
   /*
    func fetchGecmisSiparisDetayData() {
        
        let userUID = UserModel.shared.uid
        
        
        let gecmisSiparislerRef = Database.database().reference().child("Users/\(userUID)/GecmisSiparisler")
        
        gecmisSiparislerRef.observeSingleEvent(of: .value) { (snapshot) in
            if let gecmisSiparisData = snapshot.value as? [String: [String: Any]] {
                for (_, siparisDetay) in gecmisSiparisData {
                    if let siparisTarihi = siparisDetay["siparis_tarihi"] as? String,
                       let tur = siparisDetay["tur"] as? String,
                       let ucret = siparisDetay["ucret"] as? String,
                       let urunler = siparisDetay["urunler"] as? [[String: Any]] {
                        
                        var urunlerString = ""
                        for urun in urunler {
                            if let count = urun["count"] as? String,
                               let productId = urun["productId"] as? String {
                                urunlerString.append("\(count) adet \(productId), ")
                            }
                        }
                        
                        urunlerString = String(urunlerString.dropLast(2)) // Son virgül ve boşluk karakterlerini kaldır
                        print("Not: \(siparisDetay["not"] as? String ?? "")")
                        print("Sipariş Tarihi: \(siparisTarihi)")
                        print("Tür: \(tur)")
                        print("Ücret: \(ucret)")
                        print("Ürünler: \(urunlerString)")
                        self.payArray.append(ucret)
                        self.noteArray.append(siparisDetay["not"] as? String ?? "")
                        self.dateArray.append(siparisTarihi)
                    }
                }
                
                self.tableView.reloadData() // TableView'yi güncellemeyi unutmayın
            }
        } withCancel: { (error) in
            print("Firebase GecmisSiparisler veri alma hatası: \(error.localizedDescription)")
        }
    }*/
}

extension PastProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PastProductCell
        
        let urun = productLists[indexPath.row]
        cell.payLabel.text = String(urun.ucret!)
        cell.noteLabel.text = urun.not
        cell.dateLabel.text = urun.siparisTarihi
       // print("s" + urun.not)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = productLists[indexPath.row]
        navigateToProductDetail(selectedOrder: selectedOrder)
    }

    func navigateToProductDetail(selectedOrder: PastOrderModel) {
        guard let productDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PastOrdersVC") as? PastOrdersVC else {
            return
        }
        productDetailVC.selectedCategory = selectedOrder
        navigationController?.pushViewController(productDetailVC, animated: true)
    }

}
extension PastProductVC {
    func photoTapped(at category: PastProductItem) {
        
        //print("Photo tapped at index: \(id)")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PastOrdersVC") as! PastOrdersVC
        //next.selectedCategory = category
        //next.photoData = photoData
        //self.present(next, animated: true, completion: nil)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}


