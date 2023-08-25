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
    var selectedDetail : ProductDetail?
    var detailList = [ProductDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        fetchRealtimeDatabaseData()
         
        
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
        let ref = Database.database().reference().child("SubCategories").child("\(selectedDetail?.id ?? 0)")
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


    
    
    
    func fetchRealtimeDatabaseData() {
        
            let db = Database.database().reference().child("SubCategories")
            db.observeSingleEvent(of: .value) { (snapshot) in
                guard let filmsSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    print("Realtime Database'den veri çekerken hata oluştu.")
                    return
                }
                
                // Realtime Database verilerini sinemaListesi'ne ekleyelim
                for filmSnapshot in filmsSnapshot {
                    
                    let detailData = filmSnapshot.value as! [String: Any]
                    if let name = detailData["name"] as? String,
                     let id = detailData["id"] as? Int,
                     let image = detailData["Image"] as? String,
                       let pay = detailData["productFee"] as? String {
                        let film = ProductDetail(id: id, productName: name, productImageURL: image, productPay: pay)
                        self.detailList.append(film)
                    }
                }
                
                // Realtime Database verilerini aldıktan sonra gridview'i yenile
                self.collectionView.reloadData()
            }
        
        }

    @IBAction func DetailButtonClicked(_ sender: Any) {
        
    }
    

}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCollectionVC", for: indexPath) as! SuggestionCollectionVC
        let film = detailList[indexPath.row]
        cell.suggestionDetailLabel.text = film.productName
        cell.suggestionPayLabel.text = film.productPay
        cell.suggestionImageView.sd_setImage(with: URL(string: film.productImageURL))
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
