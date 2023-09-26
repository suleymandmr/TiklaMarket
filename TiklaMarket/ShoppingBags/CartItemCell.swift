//
//  CartItemCell.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 16.09.2023.
//

import UIKit

class CartItemCell: UITableViewCell {

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with item: CartItem) {
        itemNameLabel.text = item.productName
        itemPriceLabel.text = "$\(item.productPrice)"
       }

}
