//
//  TableViewCellForMainTable.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 13.05.2022.
//

import UIKit

class CryptoTableViewCell1: UITableViewCell {

    @IBOutlet weak var imageCoinView: UIImageView!
    @IBOutlet weak var nameCoinLabel: UILabel!
    @IBOutlet weak var priceChangePercentage24hLabel: UILabel!
    @IBOutlet weak var priceCoinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: CryptoTableViewCellViewModelProtocol! {
        didSet {
            guard let imageData = viewModel.imageCoinView else { return }
            imageCoinView.image = UIImage(data: imageData)
            nameCoinLabel.text = viewModel.coinName
            priceChangePercentage24hLabel.text = viewModel.priceChangePercentage24h
            priceCoinLabel.text = viewModel.price
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
