import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

enum AddressType: String {
    case home = "Home"
    case office = "Office"
}

class AddressVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var addressDataArray = [(image: String, title: String, location: String)]() // Tüm verileri saklayacak dizi
    var addresArray = [AddressModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchDataFromRealtimeDatabase()
    }

    func fetchDataFromRealtimeDatabase() {
        
        let databaseRef = Database.database().reference().child("Users/\(UserModel.shared.uid)/address")
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                // Verileri çek ve işle
                for (_, data) in value {
                    if let dataDict = data as? [String: Any],
                        let image = dataDict["type"] as? String,
                        let title = dataDict["title"] as? String,
                        let location = dataDict["description"] as? String {
                        self.addressDataArray.append((image, title, location))
                    }
                }
                
                // Verileri aldıktan sonra tabloyu güncelle
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
        return addressDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressCell
        let data = addressDataArray[indexPath.row]
        cell.titleLabel.text = data.title
        cell.locationLabel.text = data.location
        cell.addressImageView.sd_setImage(with: URL(string: data.image))
        cell.setupConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            if editingStyle == .delete {
                let address = self.addresArray
                let addressId = AddressModel.shared.adressId
                print("adres\(addressId)")
                let addresses = AddressModel()
              //  addressId.adressId = snapshot.key  //<-  this is the important part
             //   addressId.title = snapshot.childSnapshot("post_text") as? String ?? "No Text"
               
                Database.database().reference().child("Users/\(UserModel.shared.uid)/address").child(addressId).removeValue()
               
            self.addresArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                
            }
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
