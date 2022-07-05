//
//  MainViewControllerViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 14.05.2022.
//

import Foundation
import UIKit

protocol MainViewControllerViewModelProtocol: AnyObject {
    var viewModelDidChange: (() -> ())? { get set }
    func featchData(complition: @escaping () -> ())
    func updateCoinData(complition: @escaping () -> ())
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewControllerViewModelProtocol
    func filterCoinsForSearchText(searchText: String)
}

class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    private var searchTextIsEmpty = true
    
    var viewModelDidChange: (() -> ())?
    
    func updateCoinData(complition: @escaping () -> ()) {
        NetworkManager.shared.fetchData { coins in
            CacheData.shared.setCoins(coins: coins)
            DispatchQueue.main.async {
                complition()
            }
        }
    }
    
    func featchData(complition: @escaping () -> ()) {
        if CacheData.shared.coinsIsEmpty() {
            updateCoinData {
                complition()
            }
        }
    }
    
    func numberOfRows() -> Int {
        searchTextIsEmpty ? CacheData.shared.countCoins() : CacheData.shared.countFilteredCoins()
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol {
        if searchTextIsEmpty {
            let coin = CacheData.shared.getCoin(at: indexPath)
            return CryptoTableViewCellViewModel(coin: coin)
        } else {
            let coin = CacheData.shared.getFilteredCoin(at: indexPath)
            return CryptoTableViewCellViewModel(coin: coin)
        }
    }
    
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewControllerViewModelProtocol {
        if searchTextIsEmpty {
            let coin = CacheData.shared.getCoin(at: indexPath)
            return DetailCoinViewControllerViewModel(coin: coin)
        }else {
            let coin = CacheData.shared.getFilteredCoin(at: indexPath)
            return DetailCoinViewControllerViewModel(coin: coin)
        }
        
    }
    
    func filterCoinsForSearchText(searchText: String) {
        searchTextIsEmpty = searchText.isEmpty
        let filteredCoins = CacheData.shared.getCoins().filter({ coin in
            return coin.name.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async { [unowned self] in
            CacheData.shared.setFilteredCoins(filteredCoins: filteredCoins)
            viewModelDidChange?()
        }
        
    }
}
