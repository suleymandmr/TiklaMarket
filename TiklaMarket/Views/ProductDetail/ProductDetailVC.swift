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
        guard var selectedProduct = self.selectedProduct else {
               return
           }
           
           if let count = Int(pieceLabel.text ?? "0") {
               // Update the count property of the selected product
               selectedProduct.count = count
               
               if var bags = UserModel.shared.details.bags {
                   if let index = bags.products.firstIndex(where: { $0.id == selectedProduct.id }) {
                       // Update the count of the product in the cart by adding to the existing count
                       bags.products[index].count! += count
                   } else {
                       // If the product is not in the cart, add it
                       bags.products.append(selectedProduct)
                   }
                   bags.totalPrice += (Double(selectedProduct.pay!) ?? 0) * Double(count)
                   UserModel.shared.details.bags = bags
               } else {
                   // If the user's cart is empty, create a new cart with the selected product
                   UserModel.shared.details.bags = BagsModel()
               }
               
            // Toplam fiyatı güncelle
            UserModel.shared.details.bags?.totalPrice += (Double(selectedProduct.pay!) ?? 0) * Double(count)
            
            // Firebase veritabanına güncellemeleri kaydetmek (Firebase kullanılıyorsa)
            let ref = Database.database().reference()
            let bagsRef = ref.child("Users/\(UserModel.shared.uid)/bags")
            bagsRef.setValue(UserModel.shared.details.bags?.getAllData())
            
            // Başarılı bir şekilde ürünü sepete eklediğinizden emin olun
            print("Ürün sepete eklendi.")
            
            // İhtiyaçlarınıza göre ek işlemleri yapabilirsiniz.
        }
    }

}
