//
//  Api.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 22.08.2023.
//

import Foundation
import Firebase


class Api{
    
    func getProductData(selectedID: Int)async->[Product]?{
        
        var activeProductList:[Product] = []
      
            
            /*let db = Database.database().reference().child("SubCategories")
                db.observeSingleEvent(of: .value) { (snapshot) in
                    // Veri çekme işlemi tamamlandıktan sonra çalışacak kapanma fonksiyonu
                    // snapshot içerisindeki çocuk verileri alın
                    guard let subCategorySnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                        print("Realtime Database'den veri çekerken hata oluştu.")
                        return
                    }
                
                    // Realtime Database verilerini pruductList listesine ekleyelim
                    for subCategorySnapshot in subCategorySnapshots {
                        let subCategoryId = subCategorySnapshot.key
                        
                        if let subCategoryData = subCategorySnapshot.value as? [String: Any],
                           let name = subCategoryData["name"] as? String,
                           let imageURL = subCategoryData["Image"] as? String,
                           let categoryId = subCategoryData["category_id"] as? Int
                        {
                            let subCategory = Product(productName: name, id: subCategoryId, productImageURL: imageURL)
                            if(categoryId == selectedID ){
                                activeProductList.append(subCategory)
                            }
                        }
                    }
                    print("actıve data ",activeProductList)
                }*/
        
        do{
            let db = try await Database.database().reference().child("SubCategories").getData()
    
            guard let subCategorySnapshots = db.children.allObjects as? [DataSnapshot] else {
                print("Realtime Database'den veri çekerken hata oluştu.")
                return []
            }
        
            // Realtime Database verilerini pruductList listesine ekleyelim
            for subCategorySnapshot in subCategorySnapshots {
                let subCategoryId = subCategorySnapshot.key
                
                if let subCategoryData = subCategorySnapshot.value as? [String: Any],
                   let name = subCategoryData["name"] as? String,
                   let imageURL = subCategoryData["Image"] as? String,
                   let categoryId = subCategoryData["category_id"] as? Int,
                   let pay = subCategoryData["productFee"] as? String
                {
                    let subCategory = Product(productName: name, id: subCategoryId, productImageURL: imageURL, productPay: pay)
                    if(categoryId == selectedID ){
                        activeProductList.append(subCategory)
                    }
                }
            }
            return activeProductList
        } catch{
            //print("ERR")
            return activeProductList
        }
    }
    func getProductDetailData(selectedID: Int) async->[ProductDetail]?{
        
        var activeProductList:[ProductDetail] = []
        do{
            let db = try await Database.database().reference().child("SubCategories").getData()
            
            guard let subCategorySnapshots = db.children.allObjects as? [DataSnapshot] else {
                print("Realtime Database'den veri çekerken hata oluştu.")
                return []
            }
            
                // Realtime Database verilerini pruductList listesine ekleyelim
                for subCategorySnapshot in subCategorySnapshots {
                    let subCategoryId = subCategorySnapshot.key
                    
                    if let subCategoryData = subCategorySnapshot.value as? [String: Any],
                       let name = subCategoryData["name"] as? String,
                       let imageURL = subCategoryData["Image"] as? String,
                       let categoryId = subCategoryData["category_id"] as? Int,
                       let pay = subCategoryData["productFee"] as? String
                    {
                        let subCategory = ProductDetail(id: subCategoryId, productName: name, productImageURL: imageURL, productPay: pay)
                        if(categoryId == selectedID ){
                            activeProductList.append(subCategory)
                        }
                    }
                }
                return activeProductList
            } catch{
                //print("ERR")
                return activeProductList
            }
            
            
        }
    }

