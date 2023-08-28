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

    @IBOutlet weak var ProductDetailImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ProductDetailLabel: UILabel!
    @IBOutlet weak var ProductDetailPayLabel: UILabel!
    
    
    var selectedDetail : Category?
    var detailList = [ProductDetail]()
    var relatedProducts: [Product] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedDetail?.id as Any)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        Task{
            await fetchRealtimeDatabaseData()
        }
        
         
        
            let layout = UICollectionViewFlowLayout()
            let cellWidth: CGFloat = 80 // Sabit genişlik değeri
            let cellHeight: CGFloat = 120 // Sabit yükseklik değeri
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            collectionView!.collectionViewLayout = layout
          
        fetchFirebaseData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func fetchFirebaseData() {
        let ref = Database.database().reference().child("SubCategories").child("\(selectedDetail?.id )")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dataDict = snapshot.value as? [String: Any] {
                
                if let imageUrl = dataDict["Image"] as? String {
                    self.ProductDetailImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                }

                if let label1Text = dataDict["name"] as? String {
                    self.ProductDetailLabel.text = label1Text
                }

                if let label2Text = dataDict["productFee"] as? String {
                    self.ProductDetailPayLabel.text = label2Text
                }
            }
        }
    }


    
    
    
    func fetchRealtimeDatabaseData() async {
        do{
            print("CLICKED", self.selectedDetail?.id)
          /*  let data = await Api().getProductDetailData(selectedID: self.selectedDetail!.id)
            print("DATA", data as Any)
            self.activeDetailList = data!
            self.collectionView.reloadData()*/
        }catch{
            print("ERR2")
        }
            
        
        }

    @IBAction func DetailButtonClicked(_ sender: Any) {
        
    }
    

}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCollectionVC", for: indexPath) as! SuggestionCollectionVC
        let film = relatedProducts[indexPath.row]
        cell.suggestionDetailLabel.text = film.productName
        cell.suggestionPayLabel.text = film.productPay
        cell.suggestionImageView.sd_setImage(with: URL(string: film.productImageURL))
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
