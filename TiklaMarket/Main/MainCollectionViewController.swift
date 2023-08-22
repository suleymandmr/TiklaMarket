//
//  MainCollectionViewController.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 21.08.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {
    var products: [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionVC", for: indexPath) as! MainCollectionVC
           let product = products[indexPath.item]  // Burada products dizisi içindeki ürünü alıyorsunuz
           cell.configure(with: product)
           return cell
       }

       override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let product = products[indexPath.item]
           performSegue(withIdentifier: "ProductCollectionVC", sender: product)
       }

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ProductCollectionVC", let product = sender as? Product {
               if segue.destination is ProductVC {
                  // detailViewController.selectedProductId = product.productName
               }
           }
       }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

   

}
