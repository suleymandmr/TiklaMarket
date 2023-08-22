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
    var selectedProductId: Int = 0
    var selectedCategory: Category?
    
    var activeProductList: [Product] = []
    
    
    
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    var isShowingFirstSegmentData = true
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
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
        
        Task{
            await fetchRealtimeDatabaseData()
        }

        fetchButtonData()
         }
 

    func fetchRealtimeDatabaseData() async{
        do{
            // Firebase Realtime Database referansını oluşturun ve alt kategori verilerini çekin
            var data = await Api().getProductData(selectedID: selectedCategory!.id)
            //print("DATA ",data)
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
            
            self.buttonsCollectionView.reloadData()
        }
    }
    
 
}
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == buttonsCollectionView {
          
              return buttonTitles.count
        } else {
            return activeProductList.count
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
            let film = activeProductList[indexPath.row]
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

