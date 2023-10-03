//
//  PastProductCell.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.09.2023.
//

import UIKit

class PastProductCell: UITableViewCell {

    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
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
