//
//  ProductDetailVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 23.08.2023.
//

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
    
    var selectedProduct : Product?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let data = selectedProduct{
            ProductDetailLabel.text = data.productName
            ProductDetailPayLabel.text = data.productPay
           // ProductDetailImageView.image = data.productImageURL
            detailTextLabel.text = data.productSubject
            detailTextLabel.isEditable = false
            
            if let imageUrl = URL(string: data.productImageURL),
               let imageData = try? Data(contentsOf: imageUrl),
               let productImage = UIImage(data: imageData){
                ProductDetailImageView.image = productImage
            }
            
            
        }
    }

    @IBAction func DetailButtonClicked(_ sender: Any) {
        
    }
    

}

