import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class BagsVC: UIViewController {
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var shoppingCartItems = [ShoppingCartItem]()
    //var bagsDataArray : [Bags] = []
    var nameArray = [String]()
    var imageArray = [String]()
    var feeArray = [String]()
    var payArray = [String]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserModel.shared.details.bags!.remove(at: indexPath.row)
            do {
              /* let encoder = JSONEncoder()
                let user = try encoder.encode(UserModel.shared)
                UserDefaults.standard.set(user, forKey: UserDefaultsKeys.userData.rawValue)
                let arr = UserModel.shared.details.bags!.map({ $0.getAllData() })
                let ref = Database.database().reference()
                let userRef = ref.child("Users/"+UserModel.shared.uid+"/bags")
                userRef.setValue(arr)*/
                

            } catch { }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModel.shared.details.bags?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BagsCell
       /* cell.productNameLabel.text = UserModel.shared.details.bags![indexPath.row].name
        cell.productFeeLabel.text = UserModel.shared.details.bags![indexPath.row].productFee
        cell.payLabel.text = payArray[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]))*/
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
