//
//  FavoritCoinsViewControllerViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 07.06.2022.
//

import Foundation

protocol FavoritCoinsViewControllerViewModelProtocol: MainViewControllerViewModelProtocol {
}


class FavoritCoinsViewControllerViewModel: FavoritCoinsViewControllerViewModelProtocol {
    private var searchTextIsEmpty = true
    
    var viewModelDidChange: (() -> ())?
    
    func updateCoinData(complition: @escaping () -> ()) {
        NetworkManager.shared.fetchData { coins in
            CacheData.shared.setCoins(coins: coins)
            CacheData.shared.setFavouriteCoins()
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
        }else {
            CacheData.shared.setFavouriteCoins()
            complition()
        }
    }
    
    func numberOfRows() -> Int {
        searchTextIsEmpty ? CacheData.shared.countFavouriteCoins() : CacheData.shared.countFilteredCoins()
    }
    
    func cellViewModel(at indexPath: IndexPath) -> (CryptoTableViewCellViewModelProtocol) {
        if searchTextIsEmpty {
            let coin = CacheData.shared.getFavouriteCoin(at: indexPath)
            return CryptoTableViewCellViewModel(coin: coin)
        }else {
            let coin = CacheData.shared.getFilteredCoin(at: indexPath)
            return CryptoTableViewCellViewModel(coin: coin)
        }
    }
    
    func detailViewModel(at indexPath: IndexPath) -> (DetailCoinViewViewModelProtocol) {
        if searchTextIsEmpty {
            let coin = CacheData.shared.getFavouriteCoin(at: indexPath)
            return DetailCoinViewControllerViewModel(coin: coin)
        }else {
            let coin = CacheData.shared.getFilteredCoin(at: indexPath)
            return DetailCoinViewControllerViewModel(coin: coin)
        }
    }
    
    func filterCoinsForSearchText(searchText: String) {
        searchTextIsEmpty = searchText.isEmpty
        let filteredCoins = CacheData.shared.getFavouriteCoins().filter({ coin in
            coin.name.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async { [unowned self] in
            CacheData.shared.setFilteredCoins(filteredCoins: filteredCoins)
            viewModelDidChange?()
        }
    }
}
