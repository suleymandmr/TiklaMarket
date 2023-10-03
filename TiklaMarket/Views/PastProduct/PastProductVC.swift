import UIKit
import Firebase

class PastProductVC: UIViewController {
    var arrat = [String]()
    var payArray = [String]()
    var noteArray = [String]()
    var dateArray = [String]()
    var productList = [PastProductItem]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchGecmisSiparisDetayData()
    }
    
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
    }
}

extension PastProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PastProductCell
        
        cell.payLabel.text = payArray[indexPath.row]
        cell.noteLabel.text = noteArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = productList[indexPath.row]
        photoTapped(at: category)
        
    }
    
}
extension PastProductVC {
    func photoTapped(at category: PastProductItem) {
        
        //print("Photo tapped at index: \(id)")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PastOrdersVC") as! PastOrdersVC
        next.selectedCategory = category
        //next.photoData = photoData
        //self.present(next, animated: true, completion: nil)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}


