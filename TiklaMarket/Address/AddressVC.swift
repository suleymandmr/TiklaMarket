//
//  AddressVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

enum AddressType:String{
    case home
    case office
}

class AddressVC: UIViewController {
        var officeImageURL = "https://cdn0.iconfinder.com/data/icons/business-1390/24/20_-_Company-2-512.png"
        var homeImageURL = "https://cdn0.iconfinder.com/data/icons/expenses-vs-income/30/__house_home_flat_facilities-512.png"
  
    @IBOutlet weak var tableView: UITableView!
    var typeArray = [String]()
    var imageArray = [String]()
    var titleArray = [String]()
    var locationArray = [String]()
    var itemIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromRealtimeDatabase()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Haritayı yeniden yüklemek için viewWillAppear'ı çağırın
        viewWillAppear(false)
    }
    
    func fetchDataFromRealtimeDatabase() {
        
        //let databaseRefe = Database.database().reference().child("Users/"+UserModel.shared.uid+"/address/").childByAutoId()
        //print("TESTDENEME\(databaseRefe)")
        
        let databaseRef = Database.database().reference().child("Users/\(UserModel.shared.uid)/address")
         databaseRef.observeSingleEvent(of: .value) { (snapshot) in
             if let value = snapshot.value as? [String: Any] {
                 // Verileri çek ve işle
                 for (_, data) in value {
                     if let dataDict = data as? [String: Any],
                         let type = dataDict["type"] as? String,
                         let title = dataDict["title"] as? String,
                         let location = dataDict["district"] as? String
                     {
                         self.typeArray.append(type)
                         self.titleArray.append(title)
                         self.locationArray.append(location)
                     }
                 }
                 
                 // Verileri aldıktan sonra işlem yapabilirsiniz (örneğin, bir tabloyu güncelleme)
                 self.tableView.reloadData()
             }
         } withCancel: { (error) in
             print("Firebase Realtime Database veri alma hatası: \(error.localizedDescription)")
         }
        
     }
     
    @IBAction func nextViewClicted(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "MapVC") as? MapVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(false)
            
        }
    }
    
}

extension AddressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
               // Firebase Realtime Database referansını alın
               let databaseRef = Database.database().reference()
            let itemID = databaseRef.child("Users/\(UserModel.shared.uid)/address").childByAutoId().key
          //  databaseRef.child("Users/\(UserModel.shared.uid)/address/\(itemID)").setValue(titleArray)
            let itemIDToDelete = itemIDs[indexPath.row] // Özel ID'leri saklayan bir dizi kullanmalısınız
                   
                  // Silinecek verinin yolunu oluşturun
                  let path = "Users/\(UserModel.shared.uid)/address/\(itemIDToDelete)"
                  
                  // Veriyi silme işlemi
                  databaseRef.child(path).removeValue { (error, _) in
                      if let error = error {
                          print("Veri silme hatası:", error.localizedDescription)
                      } else {
                          print("Veri başarıyla silindi.")
                      }
                  }
                  
                  // Diziden öğeyi ve özel ID'sini kaldırın
                  titleArray.remove(at: indexPath.row)
                  itemIDs.remove(at: indexPath.row)
                  tableView.deleteRows(at: [indexPath], with: .fade)
              }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressCell
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.locationLabel.text = locationArray[indexPath.row]
        
            
            if let type = typeArray[indexPath.row] as? String {
                if type == "home" {
                    // "home" tipi için özel bir resim URL'si kullanın
                    if let homeImageUrl = URL(string: self.homeImageURL) {
                        cell.addressImageView.sd_setImage(with: homeImageUrl)
                    } else {
                        // URL geçersiz veya boşsa, varsayılan bir resim göstermek isterseniz burada gösterebilirsiniz.
                        cell.addressImageView.image = UIImage(named: "defaultHomeImage")
                    }
                } else if type == "office" {
                    // "office" tipi için özel bir resim URL'si kullanın
                    if let officeImageUrl = URL(string: self.officeImageURL) {
                        cell.addressImageView.sd_setImage(with: officeImageUrl)
                    } else {
                        // URL geçersiz veya boşsa, varsayılan bir resim göstermek isterseniz burada gösterebilirsiniz.
                        cell.addressImageView.image = UIImage(named: "defaultOfficeImage")
                    }
                }
            }
            
            cell.setupConstraints()
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = typeArray[indexPath.row]
        let selectedTitle = titleArray[indexPath.row]
        let selectedLocation = locationArray[indexPath.row]
        
        print("Seçilen Tip: \(selectedType)")
        print("Seçilen Başlık: \(selectedTitle)")
        print("Seçilen Lokasyon: \(selectedLocation)")
        
        // Eğer latitude ve longitude değerlerini Firebase'den almak istiyorsanız, burada gerekli sorguyu yapabilirsiniz.
        
        // Örneğin, seçilen başlığa göre Firebase'den verileri almak için:
        let databaseRef = Database.database().reference().child("Users/"+UserModel.shared.uid+"/address")
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                for (_, data) in value {
                    if let dataDict = data as? [String: Any],
                       let type = dataDict["type"] as? String,
                       let title = dataDict["title"] as? String,
                       let location = dataDict["district"] as? String,
                       let latitude = dataDict["latitude"] as? Double, // Örnek: Firebase'den latitude değerini alın
                       let longitude = dataDict["longitude"] as? Double // Örnek: Firebase'den longitude değerini alın
                    {
                        if title == selectedTitle {
                            // Seçilen başlığa göre latitude ve longitude değerlerini kullanabilirsiniz.
                            print("Seçilen Konumun Latitude: \(latitude), Longitude: \(longitude)")
                        }
                    }
                }
            }
        } withCancel: { (error) in
            print("Firebase Realtime Database veri alma hatası: \(error.localizedDescription)")
        }
    }


    
    
}
    
