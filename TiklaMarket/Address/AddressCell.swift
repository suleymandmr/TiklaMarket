//
//  AddressCell.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 7.09.2023.
//

import UIKit

class AddressCell: UITableViewCell {

    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupConstraints() {
        /*detayImageView.translatesAutoresizingMaskIntoConstraints = false
        detayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detayImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            detayImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            detayImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            detayImageView.widthAnchor.constraint(equalToConstant: 60),
            
            detayLabel.leadingAnchor.constraint(equalTo: detayImageView.trailingAnchor, constant: 8),
            detayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),*/
        //])
    }

}
