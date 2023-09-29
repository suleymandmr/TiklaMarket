//
//  BagsVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 7.09.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
class BagsVC: UIViewController {
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var shoppingCartItems = [ShoppingCartItem]()
    var bagsDataArray : [Bags] = []
    var nameArray = [String]()
    var imageArray = [String]()
    var feeArray = [String]()
    var payArray = [String]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromRealtimeDatabase()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        
       
    }
   /* func fetchDataFromRealtimeDatabase() {
        
        let databaseRef = Database.database().reference().child("Users/"+UserModel.shared.uid+"/Bags")
         databaseRef.observeSingleEvent(of: .value) { (snapshot) in
             if let value = snapshot.value as? [String: Any] {
                 // Verileri çek ve işle
                 for (_, data) in value {
                     if let dataDict = data as? [String: Any],
                         let name = dataDict["name"] as? String,
                         let fee = dataDict["fee"] as? String,
                         let image = dataDict["Image"] as? String
                     {
                         self.nameArray.append(name)
                         self.feeArray.append(fee)
                         self.imageArray.append(image)
                     }
                 }
                 
                 // Verileri aldıktan sonra işlem yapabilirsiniz (örneğin, bir tabloyu güncelleme)
                 self.tableView.reloadData()
             }
         } withCancel: { (error) in
             print("Firebase Realtime Database veri alma hatası: \(error.localizedDescription)")
         }
     }*/
   
    
    func fetchDataFromRealtimeDatabase() {
          let userUID = UserModel.shared.uid // Kullanıcının UID'si

          // Kullanıcının çantasındaki ürünleri çekmek için referansı oluşturun
          let bagsRef = Database.database().reference().child("Users/\(userUID)/Bags")
          let productsRef = Database.database().reference().child("Products")

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
                                          let image = productData["Image"] as? String
                                          self.nameArray.append(name!)
                                          self.feeArray.append(fee!)
                                          self.imageArray.append(image!)
                                          self.payArray.append(countString + " adet")
                                          self.tableView.reloadData()
                                          // Toplam ücreti güncelle
                                          self.updateTotalFee()
                                      }
                                  }) { (error) in
                                      print("Firebase Products veri alma hatası: \(error.localizedDescription)")
                                  }
                              }
                          }
                      }
                  }
              }
          } withCancel: { (error) in
              print("Firebase Bags veri alma hatası: \(error.localizedDescription)")
          }
      }

      func updateTotalFee() {
          var totalFee = 0.0

          for (index, feeString) in feeArray.enumerated() {
              if let fee = Double(feeString),
                 let count = Int(payArray[index].replacingOccurrences(of: " adet", with: "")) {
                  totalFee += fee * Double(count)
              }
          }

          // Toplam ücreti feeLabel üzerinde göster
          feeLabel.text = "\(totalFee) tl"
      }

    @IBAction func confirmCartClicked(_ sender: Any) {
        if let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC {
               // PaymentVC'yi göster
               self.navigationController?.pushViewController(paymentViewController, animated: true)
           }
    }
}
extension BagsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BagsCell
       
        cell.productNameLabel.text = nameArray[indexPath.row]
        cell.productFeeLabel.text = feeArray[indexPath.row]
        cell.payLabel.text = payArray[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
    
