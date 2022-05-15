//
//  DetailCoinViewControllerViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 14.05.2022.
//

import Foundation

protocol DetailCoinViewControllerViewModelProtocol: AnyObject {
    init(coin: Coin)
    var coinName: String { get }
    var coinPrice: String { get }
    var marketCap: String { get }
    var curculatinSupply: String { get }
    var maxSupply: String { get }
    var height24h: String { get }
    var low24h: String { get }
    var priceChange24h: String { get }
    var isFavorit: Bool { get }
    var viewModelDidChange: ((DetailCoinViewControllerViewModelProtocol) -> ())? { get set }
    func favoritToggle()
}

class DetailCoinViewControllerViewModel: DetailCoinViewControllerViewModelProtocol {
    required init(coin: Coin) {
        self.coin = coin
    }
    
    let coin: Coin
    
    var viewModelDidChange: ((DetailCoinViewControllerViewModelProtocol) -> ())?
    
    var coinName: String {
        coin.name
    }
    
    var coinPrice: String {
        "\(coin.current_price)"
    }
    
    var marketCap: String {
        "\(coin.market_cap)"
    }
    
    var curculatinSupply: String {
        guard let curculatinSupply = coin.circulating_supply else { return "No Data" }
        return "\(curculatinSupply)"
    }
    
    var maxSupply: String {
        guard let maxSupply = coin.max_supply else { return "No Data" }
        return "\(maxSupply)"
    }
    
    var height24h: String {
        "\(coin.high_24h)"
    }
    
    var low24h: String {
        "\(coin.low_24h)"
    }
    
    var priceChange24h: String {
        "\(coin.price_change_percentage_24h)"
    }
    
    var isFavorit: Bool {
        get {
            DataManager.shared.getFavoriteStatus(for: coin.name)
        }
        set {
            DataManager.shared.setFavoriteStatus(for: coin.name, with: newValue)
            viewModelDidChange?(self)
        }
    }
    
    func favoritToggle() {
        isFavorit.toggle()
    }
    
}
