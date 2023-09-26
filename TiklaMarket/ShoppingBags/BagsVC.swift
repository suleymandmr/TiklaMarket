//
//  BagsVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 7.09.2023.
//

import UIKit
import Firebase

class BagsVC: UIViewController,  UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var shoppingCartItems: [CartItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Firebase Firestore referansını alın
              let db = Firestore.firestore()
              
              // Firestore'dan sepet öğelerini getirin
              db.collection("Products").getDocuments { (querySnapshot, error) in
                  if let error = error {
                      print("Hata: \(error)")
                      return
                  }
                  
                  // Firestore verilerini diziye dönüştürün
                  for document in querySnapshot!.documents {
                      let data = document.data()
                      if let itemName = data["name"] as? String,
                         let itemPrice = data["productFee"] as? Double {
                          let cartItem = CartItem(name: itemName, price: itemPrice)
                          self.shoppingCartItems.append(cartItem)
                      }
                  }
                  
                  // Tabloyu yeniden yükleyin ve sepet öğelerini gösterin
                  self.tableView.reloadData()
              }
    }
    
    // UITableView veri kaynağı işlevleri
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath)
        let item = shoppingCartItems[indexPath.row]
        cell.textLabel?.text = item.productName
        cell.detailTextLabel?.text = "$\(item.productPrice)"
        return cell
    }
    
    // Sepetten öğe silme işlemi
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedItem = shoppingCartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Firestore'dan öğeyi silin
            let db = Firestore.firestore()
            db.collection("Products").document(deletedItem.productName).delete { (error) in
                if let error = error {
                    print("Hata: \(error)")
                } else {
                    print("Öğe silindi: \(deletedItem.productName)")
                }
            }
        }
    }



}
