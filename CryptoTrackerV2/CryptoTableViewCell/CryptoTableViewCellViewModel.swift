//
//  CryptoTableViewCellViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 14.05.2022.
//

import Foundation

protocol CryptoTableViewCellViewModelProtocol {
    var imageCoinView: Data? { get }
    var coinName: String { get }
    var priceChangePercentage24h: String { get }
    var price: String { get }
    init (coin: Coin)
}

class CryptoTableViewCellViewModel: CryptoTableViewCellViewModelProtocol {
    var coin: Coin
    
    var imageCoinView: Data? {
        ImageManager.shared.fetchImageData(from: coin.image)
    }
    
    var coinName: String {
        coin.name
    }
    
    var priceChangePercentage24h: String {
        String("\(coin.price_change_percentage_24h) %")
    }
    
    var price: String {
        String("\(coin.current_price) $")
    }
    
    required init(coin: Coin) {
        self.coin = coin
    }
    
    
}

