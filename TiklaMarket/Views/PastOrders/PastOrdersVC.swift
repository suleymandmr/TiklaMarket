//
//  PastOrdersVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class PastOrdersVC: UIViewController {
    var pastOrderItem = [PastOrderItem]()
    var pastOrderDataArray : [PastOrder] = []
    var titleArray = [String]()
    var imageArray = [String]()
    var subjectArray = [String]()
    var selectedCategory: PastProductItem?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDataFromRealtimeDatabase()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchDataFromRealtimeDatabase() {
        let userUID = UserModel.shared.uid // Kullanıcının UID'si
        
        // Kullanıcının çantasındaki ürünleri çekmek için referansı oluşturun
        let bagsRef = Database.database().reference().child("Users/\(userUID)/bags")
        let productsRef = Database.database().reference().child("products")
        
        bagsRef.observeSingleEvent(of: .value) { (bagSnapshot) in
            if let bagData = bagSnapshot.value as? [String: Any] {
                for (bagKey, bagItems) in bagData {
                    if let bagItemsArray = bagItems as? [[String: String]] {
                        // BagItemsArray, her bir ürünün "productId" ve "count" içeren bir dizi içerir
                        for bagItem in bagItemsArray {
                            if let productId = bagItem["productId"],
                                let countString = bagItem["count"],
                               
                                let count = Int(countString) {
                                
                                // Ürünlerin tüm bilgilerini "Products" düğümünden çekin
                                productsRef.child(productId).observeSingleEvent(of: .value, with: { (productSnapshot) in
                                    if let productData = productSnapshot.value as? [String: Any] {
                                        
                                        let name = productData["name"] as? String
                                        let fee = productData["productFee"] as? String
                                       
                                        let  image = productData["Image"] as? String
                                        // Ürünün tüm bilgilerine erişebilirsiniz
                                        // let totalFee = fee * count
                                        self.titleArray.append(name!)
                                        self.subjectArray.append(fee!)
                                        self.imageArray.append(image!)
                                        //self.payArray.append(totalFee!)
                                        print("Product ID: \(productId)")
                                        print("Count: \(count)")
                                        print("Product Info: \(productData["name"])")
                                    }
                                    self.tableView.reloadData()
                                }) { (error) in
                                    print("Firebase Products veri alma hatası: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
                
                // Verileri aldıktan sonra işlem yapabilirsiniz
                // Örneğin, kullanıcının çantasındaki ürünleri listelemek
            }
        } withCancel: { (error) in
            print("Firebase Bags veri alma hatası: \(error.localizedDescription)")
        }
     }
    
    
    
    

}
extension PastOrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PastOrderCell
       
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.subjectLabel.text = subjectArray[indexPath.row]
        cell.pastOrderImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
