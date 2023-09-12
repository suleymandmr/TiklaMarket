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
        
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageArray = [String]()
    var titleArray = [String]()
    var locationArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromRealtimeDatabase()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func fetchDataFromRealtimeDatabase() {
        
        let databaseRef = Database.database().reference().child("Users/"+UserModel.shared.uid+"/address")
         databaseRef.observeSingleEvent(of: .value) { (snapshot) in
             if let value = snapshot.value as? [String: Any] {
                 // Verileri çek ve işle
                 for (_, data) in value {
                     if let dataDict = data as? [String: Any],
                        let imageArray = dataDict["adresTip"] as? String,
                        let title = dataDict["adres_baslik"] as? String,
                        let location = dataDict["mahalle_cadde_sokak"] as? String
                     {
                         self.imageArray.append(imageArray)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressCell
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.locationLabel.text = locationArray[indexPath.row]
        cell.addressImageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]) )
        cell.setupConstraints()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
    
