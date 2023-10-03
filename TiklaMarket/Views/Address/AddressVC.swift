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

class AddressVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Haritayı yeniden yüklemek için viewWillAppear'ı çağırın
        viewWillAppear(false)
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
            UserModel.shared.details.address.remove(at: indexPath.row)
            //BAŞKA BİR SAYFADA ORTAK USER UPDATE YAP
            //save device
            do {
                let encoder = JSONEncoder()
                let user = try encoder.encode(UserModel.shared)
                //save user data & password
                UserDefaults.standard.set(user, forKey: UserDefaultsKeys.userData.rawValue)
                //map filter reduce
                let arr = UserModel.shared.details.address.map({ $0.getAllData() })
                let ref = Database.database().reference()
                let userRef = ref.child("Users/"+UserModel.shared.uid+"/address")
                userRef.setValue(arr)
            } catch {}
            tableView.deleteRows(at: [indexPath], with: .fade)
          }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModel.shared.details.address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressCell
        

        cell.titleLabel.text = UserModel.shared.details.address[indexPath.row].title
        cell.locationLabel.text = UserModel.shared.details.address[indexPath.row].district
        
        switch UserModel.shared.details.address[indexPath.row].type {
        case AddressTypes.home.rawValue:
            cell.addressImageView.sd_setImage(with: URL(string:AddressImages.home.rawValue))
            break
            
        case AddressTypes.office.rawValue:
            cell.addressImageView.sd_setImage(with: URL(string: AddressImages.office.rawValue))
            break
            
            
        default:
            cell.addressImageView.sd_setImage(with: URL(string: AddressImages.office.rawValue))
            break
            
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
        let selectedType = UserModel.shared.details.address[indexPath.row].type
        let selectedTitle = UserModel.shared.details.address[indexPath.row].title
        let selectedLocation = UserModel.shared.details.address[indexPath.row].district
        
        UserModel.shared.selectedAddressID = indexPath.row
        
        print("Seçilen Tip: \(selectedType)")
        print("Seçilen Başlık: \(selectedTitle)")
        print("Seçilen Lokasyon: \(selectedLocation)")
    
    
    }


    
    
}
    
extension Sequence {
    public func toDictionary<Key: Hashable>(with selectKey: (Iterator.Element) -> Key) -> [Key:Iterator.Element] {
        var dict: [Key:Iterator.Element] = [:]
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
