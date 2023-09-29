import UIKit
import Firebase
import SDWebImage
import FirebaseStorage
import FirebaseDatabase

class ProductDetailVC: UIViewController {
    var image: UIImage?
    
    @IBOutlet weak var detailTextLabel: UITextView!
    @IBOutlet weak var ProductDetailImageView: UIImageView!
    @IBOutlet weak var ProductDetailLabel: UILabel!
    @IBOutlet weak var ProductDetailPayLabel: UILabel!
    @IBOutlet weak var pieceLabel: UILabel!
    
    @IBOutlet weak var addPieceLabel: UILabel!
    var counter = 1
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        pieceLabel.text = "\(counter)"
        
        if let data = selectedProduct {
            ProductDetailLabel.text = data.productName
            ProductDetailPayLabel.text = data.productPay
            detailTextLabel.text = data.productSubject
            detailTextLabel.isEditable = false
            
            if let imageUrl = URL(string: data.productImageURL) {
                ProductDetailImageView.sd_setImage(with: imageUrl, completed: nil)
            }
            
            let cartButton = UIBarButtonItem(title: "Sepet", style: .plain, target: self, action: #selector(goToCartButtonTapped))
            navigationItem.rightBarButtonItem = cartButton
        }
    }
    
    @objc func goToCartButtonTapped() {
        if let cartViewController = storyboard?.instantiateViewController(withIdentifier: "BagsVC") as? BagsVC {
            navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        if counter > 0 {
            counter -= 1
            pieceLabel.text = "\(counter)"
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        counter += 1
        pieceLabel.text = "\(counter)"
    }
    
    @IBAction func DetailButtonClicked(_ sender: Any) {
        guard let productID = selectedProduct?.id else {
            return
        }
        
        let userUID = UserModel.shared.uid
        let bagID = "-NfASeuuZSCyHznu1OT-"
        
        let bagsRef = Database.database().reference().child("Users/\(userUID)/Bags")
        bagsRef.observeSingleEvent(of: .value) { (bagSnapshot, error) in
            if let error = error {
               // print("Firebase Bags veri alma hatası: \(error.localizedDescription)")
                return
            }
            
            if var bagData = bagSnapshot.value as? [String: Any] {
                if var bagItems = bagData[bagID] as? [[String: Any]] {
                    if let existingItemIndex = bagItems.firstIndex(where: { $0["productId"] as? String == productID }) {
                        if let existingCountString = bagItems[existingItemIndex]["count"] as? String,
                            var existingCount = Int(existingCountString),
                            let pieceLabelText = self.pieceLabel.text,
                            let pieceLabelCount = Int(pieceLabelText) {
                            existingCount += pieceLabelCount
                            bagItems[existingItemIndex]["count"] = "\(existingCount)"
                        }
                    } else {
                        let cartItem: [String: Any] = [
                            "count": self.pieceLabel.text ?? "0",
                            "productId": productID
                        ]
                        bagItems.append(cartItem)
                    }
                    bagData[bagID] = bagItems
                    bagsRef.setValue(bagData) { (error, _) in
                        if let error = error {
                            print("Firebase veri ekleme hatası: \(error.localizedDescription)")
                        } else {
                            print("Ürün başarıyla sepete eklendi veya sayısı artırıldı.")
                        }
                    }
                } else {
                    let cartItem: [String: Any] = [
                        "count": self.pieceLabel.text ?? "0",
                        "productId": productID
                    ]
                    let newBagItems = [cartItem]
                    bagData[bagID] = newBagItems
                    bagsRef.setValue(bagData) { (error, _) in
                        if let error = error {
                            print("Firebase veri ekleme hatası: \(error.localizedDescription)")
                        } else {
                            print("Ürün başarıyla sepete eklendi.")
                        }
                    }
                }
            } else {
                let cartItem: [String: Any] = [
                    "count": self.pieceLabel.text ?? "0",
                    "productId": productID
                ]
                let newBagItems = [cartItem]
                let newBagData = [bagID: newBagItems]
                bagsRef.setValue(newBagData) { (error, _) in
                    if let error = error {
                        print("Firebase veri ekleme hatası: \(error.localizedDescription)")
                    } else {
                        print("Ürün başarıyla sepete eklendi.")
                    }
                }
            }
        }
    }
}
