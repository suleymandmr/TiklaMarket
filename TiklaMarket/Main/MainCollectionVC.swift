//
//  MainCollectionVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 15.08.2023.
//

import UIKit


class MainCollectionVC: UICollectionViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    func configure(with product: Product) {
        mainImageView.image = UIImage(named: product.productImageURL)
       }
    
}
