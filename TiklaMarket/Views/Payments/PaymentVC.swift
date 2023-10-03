//
//  PaymentVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.09.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

enum PaymantType:String{
    case Cash
    case CreditCard
}

class PaymentVC: UIViewController {
    let petments = PaymantModel()
    var payArray = [String]()
    var feeArray = [String]()
    
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var noteText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromRealtimeDatabase()
     
    }
    
    func updateTotalFee() {
        var totalFee = 0.0

           for (index, feeString) in feeArray.enumerated() {
               if let fee = Double(feeString.replacingOccurrences(of: " tl", with: "")),
                  let count = Int(payArray[index].replacingOccurrences(of: " adet", with: "")) {
                   totalFee += fee * Double(count)
               }
           }

           // Toplam ücreti feeLabel üzerinde göster
           payLabel.text = "\(totalFee) tl"
    }
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
                                           let fee = productData["productFee"] as? String
                                           self.payArray.append(countString + " adet")
                                           self.feeArray.append(fee!)
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

    
    
    @IBAction func creditCardClicked(_ sender: Any) {
        petments.type = PaymantType.CreditCard.rawValue
    }
    @IBAction func cashClicked(_ sender: Any) {
        petments.type = PaymantType.Cash.rawValue
    }
    
    @IBAction func confirmCartClicked(_ sender: Any) {
        guard let newNoteLabel = noteText.text,
                   let newPayLabel = payLabel.text else {
                 return
             }
             
        
        
        
             petments.note = newNoteLabel
             petments.pay = newPayLabel
             
             let ref = Database.database().reference()
             let userUID = UserModel.shared.uid
             let bagsRef = ref.child("Users/\(userUID)/Bags")
             let gecmisSiparislerRef = ref.child("Users/\(userUID)/GecmisSiparisler")
             
             bagsRef.observeSingleEvent(of: .value) { (bagSnapshot, _) in
                 if let bagData = bagSnapshot.value as? [String: Any] {
                     for (_, bagItems) in bagData {
                         if let bagItemsArray = bagItems as? [[String: String]] {
                             let newGecmisSiparislerRef = gecmisSiparislerRef.childByAutoId()
                             var gecmisSiparisData: [String: Any] = [:]
                             var urunlerData: [[String: Any]] = []
                             
                             for bagItem in bagItemsArray {
                                 if let productId = bagItem["productId"],
                                    let countString = bagItem["count"],
                                    let count = Int(countString) {
                                     let currentDate = Date()
                                     let dateFormatter = DateFormatter()
                                     dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                                     let siparisTarihi = dateFormatter.string(from: currentDate)
                                     
                                     gecmisSiparisData["siparis_tarihi"] = siparisTarihi
                                     gecmisSiparisData["tur"] = self.petments.type // Sipariş türü buraya eklenebilir
                                     gecmisSiparisData["ucret"] = self.petments.pay // Toplam ücret buraya eklenebilir
                                     gecmisSiparisData["not"] = newNoteLabel
                                     let urunData: [String: Any] = [
                                         "count": countString,
                                         "productId": productId
                                     ]
                                     urunlerData.append(urunData)
                                 }
                             }
                             
                             gecmisSiparisData["urunler"] = urunlerData
                             newGecmisSiparislerRef.setValue(gecmisSiparisData) { (error, _) in
                                 if let error = error {
                                     print("Firebase veri taşıma hatası: \(error.localizedDescription)")
                                 } else {
                                     print("Veriler başarıyla taşındı.")
                                     bagsRef.setValue(nil) { (error, _) in
                                         if let error = error {
                                             print("Mevcut çanta verilerini silme hatası: \(error.localizedDescription)")
                                         } else {
                                             print("Mevcut çanta verileri başarıyla silindi.")
                                         }
                                     }
                                     
                                     // Notu etiketin metni olarak ayarla
                                     self.noteText.text = newNoteLabel
                                 }
                             }
                         }
                     }
                 }
             }
         }
    
    
    
}
