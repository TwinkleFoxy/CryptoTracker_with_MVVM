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
    
    func updateCoinData(complition: @escaping (_ internetStatus: Bool) -> ()) {
        NetworkManager.shared.fetchData { coins, connectionStatus in
            connectionStatus ? CacheData.shared.setCoins(coins: coins) : print("No internet connection")
            CacheData.shared.setFavouriteCoins()
            DispatchQueue.main.async {
                complition(connectionStatus)
            }
        }
    }
    
    func featchData(complition: @escaping (_ internetStatus: Bool) -> ()) {
        if CacheData.shared.coinsIsEmpty() {
            updateCoinData { internetStatus in
                complition(internetStatus)
            }
        }else {
            CacheData.shared.setFavouriteCoins()
            complition(true)
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
