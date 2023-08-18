//
//  ViewController.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 15.08.2023.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorage
import XLPagerTabStrip

class ProductVC: UIViewController {
    var databaseRef: DatabaseReference!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var sampleData: [MyDataModel] = []
    
    var selectedCategory: Category?
    
    
    var productList: [Product] = []
    var pruduct: [String] = [String]()
    var pruductList = [Product]()
    
        var isShowingFirstSegmentData = true
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        print(selectedCategory?.baslik)
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = 80 // Sabit genişlik değeri
        let cellHeight: CGFloat = 120 // Sabit yükseklik değeri
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionView!.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        fetchRealtimeDatabaseData()
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
                    let id = filmSnapshot.key
                    let filmData = filmSnapshot.value as! [String: Any]
                    if let baslik = filmData["name"] as? String,
                       let resimAdi = filmData["Image"] as? String {
                        let film = Product(productName: baslik,id : id , productImageURL: resimAdi)
                        self.pruductList.append(film)
                    }
                }
                
                // Realtime Database verilerini aldıktan sonra gridview'i yenile
                self.collectionView.reloadData()
            }
        
        }
        
 
}
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pruductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionVC", for: indexPath) as! ProductCollectionVC
        let film = pruductList[indexPath.row]
        cell.productLabel.text = film.productName
        cell.productImageView.sd_setImage(with: URL(string: film.productImageURL))
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "", sender: nil)
        //photoTapped(at: indexPath)
    }
 
}

