//
//  CryptoCollectionViewCell.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 14.07.2022.
//

import UIKit

class CryptoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCoinView: UIImageView!
    @IBOutlet weak var nameCoinLabel: UILabel!
    @IBOutlet weak var priceChangePercentage24hLabel: UILabel!
    @IBOutlet weak var priceCoinLabel: UILabel!
    
    
    var viewModel: CryptoTableViewCellViewModelProtocol! {
        didSet {
            guard let imageData = viewModel.imageCoinView else { return }
            imageCoinView.image = UIImage(data: imageData)
            nameCoinLabel.text = viewModel.coinName
            priceChangePercentage24hLabel.text = viewModel.priceChangePercentage24h
            priceCoinLabel.text = viewModel.price
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 4, height: 8)
        layer.shadowRadius = 3
    }
}
