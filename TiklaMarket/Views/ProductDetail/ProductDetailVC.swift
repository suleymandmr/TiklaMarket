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
        
        if let product = selectedProduct {
            ProductDetailLabel.text = product.name
            ProductDetailPayLabel.text = String(product.pay!) + " ₺"
            detailTextLabel.text = product.subject
            detailTextLabel.isEditable = false
            
            if let imageUrl = URL(string: product.imageURL!) {
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
               //update device bag
               selectedProduct?.count = Int(pieceLabel.text!)
               UserModel.shared.details.bags!.totalPrice += (Double(selectedProduct!.pay!) ?? 0) * Double(selectedProduct!.count!)
               UserModel.shared.details.bags!.products.append(selectedProduct!)
               //update firebase by bag
               let arr = UserModel.shared.details.bags!.getAllData()
               let ref = Database.database().reference()
               let userRef = ref.child("Users/"+UserModel.shared.uid+"/bags")
               userRef.setValue(arr)
           }


}
