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
    
    @IBOutlet weak var goToCartButton: UIBarButtonItem!
    
    var databaseRef: DatabaseReference!
    var buttonTitles: [String] = []
    var topped: [String] = []
    var selectedCategory: Category?
    var activeProductList: [Product] = []
   
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()

    
        print(selectedCategory?.id as Any)
        
        let layoutt = UICollectionViewFlowLayout()
        layoutt.scrollDirection = .horizontal
        let cellWidtht: CGFloat = 120 // Sabit genişlik değeri
        let cellHeightt: CGFloat = 60 // Sabit yükseklik değeri
        layoutt.itemSize = CGSize(width: cellWidtht, height: cellHeightt)
        layoutt.minimumInteritemSpacing = 11
        layoutt.minimumLineSpacing = 10
        categoryCollectionView.collectionViewLayout = layoutt
        
    
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = 80 // Sabit genişlik değeri
        let cellHeight: CGFloat = 120 // Sabit yükseklik değeri
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionView!.collectionViewLayout = layout
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        
        Task {
            await fetchRealtimeDatabaseData()
        }
        
        // Özel bir buton oluşturun
            let cartButton = UIBarButtonItem(title: "Sepet", style: .plain, target: self, action: #selector(goToCartButtonTapped))
            
            // Butonu navigationItem'a ekleyin
            navigationItem.rightBarButtonItem = cartButton
        
        
        fetchButtonData()
    }
 
    @objc func goToCartButtonTapped() {
         // Sepet sayfasına yönlendirme işlemi
         // Örnek olarak, "CartViewController" adlı bir sayfaya yönlendiriyoruz
         if let cartViewController = storyboard?.instantiateViewController(withIdentifier: "BagsVC") as? BagsVC {
             navigationController?.pushViewController(cartViewController, animated: true)
         }
     }
    
    
    func fetchRealtimeDatabaseData() async{
        do{
            print("CLICKED ",self.selectedCategory?.id as Any)
            // Firebase Realtime Database referansını oluşturun ve alt kategori verilerini çekin
            let data = await Api().getProductData(selectedID: self.selectedCategory!.id)
            print("DATA ",data as Any)
            self.activeProductList = data!
            // Realtime Database verilerini aldıktan sonra gridview'i yenile
            self.collectionView.reloadData()
        }catch{
           // print("ERR2")
        }
    }
    
    func fetchButtonData() {
        let db = Database.database().reference().child("Categories")
        db.observeSingleEvent(of: .value) { (snapshot) in
            guard let buttonSnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Buttons verilerini çekerken hata oluştu.")
                return
            }
            
            for buttonSnapshot in buttonSnapshots {
                if let buttonText = buttonSnapshot.childSnapshot(forPath: "CategoryName").value as? String {
                    self.buttonTitles.append(buttonText)
                }
            }
            
            self.categoryCollectionView.reloadData()
        }
    }
    
 
}
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return buttonTitles.count
        } else {
            return activeProductList.count
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? categoryCell else {
                return UICollectionViewCell()
            }
            cell.categoryLabel.text = buttonTitles[indexPath.row]
            
            /*if indexPath.row < buttonTitles.count {
             cell.buttons.setTitle(buttonTitles[indexPath.row], for: .normal)
             } else {
             cell.buttons.setTitle("", for: .normal) // Eğer endeks geçerli değilse, boş bir metin göster
             }*/
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionVC", for: indexPath) as! ProductCollectionVC
            
            let product = activeProductList[indexPath.row] as! Product
            cell.payLabel.text = product.pay! + " tl"
            cell.productLabel.text = product.name
            cell.productImageView.sd_setImage(with: URL(string: product.imageURL!))
            return cell
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if collectionView == categoryCollectionView {
            print(buttonTitles[indexPath.row])
            
            self.selectedCategory?.id = indexPath.row+1
            self.selectedCategory?.title = buttonTitles[indexPath.row]
            
            Task{
                await fetchRealtimeDatabaseData()
            }
            
        } else {
           
           photoTapped(at: indexPath)
        }
        
        
    }
}
        extension ProductVC {
            func photoTapped(at indexPath: IndexPath) {
                
                print("Photo tapped at index: \(indexPath.row)")
                        
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
//                sonraki sayfaya sınırlı veri geçişi
//                   next.relatedProducts = Array(activeProductList[0..<1])
            let selectedProduct = activeProductList[indexPath.row]
            next.selectedProduct = selectedProduct
                    //next.photoData = photoData
                    //self.present(next, animated: true, completion: nil)
                    self.navigationController?.pushViewController(next, animated: true)
                }
 
}

