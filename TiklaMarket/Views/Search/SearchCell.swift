//
//  SearchCell.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 3.10.2023.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
