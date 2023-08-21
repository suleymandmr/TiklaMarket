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
    var buttonTitles: [String] = []
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var sampleData: [MyDataModel] = []
    
    var selectedCategory: Category?
    
    
    var productList: [Product] = []
    var pruduct: [String] = [String]()
    var pruductList = [Product]()
    
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    var isShowingFirstSegmentData = true
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        print(selectedCategory?.id)
        
        let layoutt = UICollectionViewFlowLayout()
        layoutt.scrollDirection = .horizontal
        let cellWidtht: CGFloat = 120 // Sabit genişlik değeri
        let cellHeightt: CGFloat = 50 // Sabit yükseklik değeri
        layoutt.itemSize = CGSize(width: cellWidtht, height: cellHeightt)
        layoutt.minimumInteritemSpacing = 11
        layoutt.minimumLineSpacing = 8
        buttonsCollectionView.collectionViewLayout = layoutt
        
        
        
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
        buttonsCollectionView.delegate = self
        buttonsCollectionView.dataSource = self
        fetchRealtimeDatabaseData()
        fetchButtonData()
         }
 
    
        
     
    
    func fetchRealtimeDatabaseData() {
        // Firebase Realtime Database referansını oluşturun ve alt kategori verilerini çekin
        let db = Database.database().reference().child("SubCategories")
        db.observeSingleEvent(of: .value) { (snapshot) in
            // Veri çekme işlemi tamamlandıktan sonra çalışacak kapanma fonksiyonu
            
            // snapshot içerisindeki çocuk verileri alın
            guard let subCategorySnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Realtime Database'den veri çekerken hata oluştu.")
                return
            }
            
            // Realtime Database verilerini pruductList listesine ekleyelim
            for subCategorySnapshot in subCategorySnapshots {
                let subCategoryId = subCategorySnapshot.key
                if let subCategoryData = subCategorySnapshot.value as? [String: Any],
                   let name = subCategoryData["name"] as? String,
                   let imageURL = subCategoryData["Image"] as? String
                  {
                    let subCategory = Product(productName: name, id: subCategoryId, productImageURL: imageURL)
                    self.pruductList.append(subCategory)
                }
            }
            
            // Realtime Database verilerini aldıktan sonra gridview'i yenile
            self.collectionView.reloadData()
        }
    }
    func fetchButtonData() {
        let db = Database.database().reference().child("SubCategories")
        db.observeSingleEvent(of: .value) { (snapshot) in
            guard let buttonSnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Buttons verilerini çekerken hata oluştu.")
                return
            }
            
            for buttonSnapshot in buttonSnapshots {
                if let buttonText = buttonSnapshot.childSnapshot(forPath: "title").value as? String {
                    self.buttonTitles.append(buttonText)
                }
            }
            
            self.buttonsCollectionView.reloadData()
        }
    }
    
 
}
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == buttonsCollectionView {
          return 10
            //  return buttonTitles.count
        } else {
            return pruductList.count
        }
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == buttonsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonsCell", for: indexPath) as? ButtonsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row < buttonTitles.count {
                cell.buttons.setTitle(buttonTitles[indexPath.row], for: .normal)
            } else {
                cell.buttons.setTitle("", for: .normal) // Eğer endeks geçerli değilse, boş bir metin göster
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionVC", for: indexPath) as! ProductCollectionVC
            let film = pruductList[indexPath.row]
            cell.productLabel.text = film.productName
            cell.productImageView.sd_setImage(with: URL(string: film.productImageURL))
            return cell
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "", sender: nil)
        //photoTapped(at: indexPath)
    }
 
}

