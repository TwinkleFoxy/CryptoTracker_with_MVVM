//
//  FavoritCoinsViewControllerViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 07.06.2022.
//

import Foundation

//protocol FavoritCoinsViewControllerViewModelProtocol {
//    var coins: [Coin] { get }
//    var filteredCoins: [Coin] { get }
//    var searchTextIsEmpty: Bool { get }
//    var viewModelDidChange: (() -> ())? { get set }
//    func featchData(complition: @escaping () -> ())
//    func numberOfRows() -> Int
//    func cellViewModel(at indexPath: IndexPath) -> (CryptoTableViewCellViewModelProtocol)
//    func detailViewModel(at indexPath: IndexPath) -> (DetailCoinViewControllerViewModelProtocol)
//    func filterCoinForSearchText(searchText: String) -> ()
//}

protocol FavoritCoinsViewControllerViewModelProtocol: MainViewControllerViewModelProtocol {
}


class FavoritCoinsViewControllerViewModel: FavoritCoinsViewControllerViewModelProtocol {
    var coins: [Coin] = []
    
    var filteredCoins: [Coin] = []
    
    var searchTextIsEmpty = true
    
    var viewModelDidChange: (() -> ())?
    
    func featchData(complition: @escaping () -> ()) {
        NetworkManager.shared.fetchData { [unowned self] coins in
            self.coins.removeAll()
            for coin in coins {
                if DataManager.shared.getFavoriteStatus(for: coin.name) {
                    self.coins.append(coin)
                }
            }
            DispatchQueue.main.async {
                complition()
            }
        }
    }
    
    func numberOfRows() -> Int {
        searchTextIsEmpty ? coins.count : filteredCoins.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> (CryptoTableViewCellViewModelProtocol) {
        if searchTextIsEmpty {
            let coin = coins[indexPath.row]
            return CryptoTableViewCellViewModel(coin: coin)
        }else {
            let coin = filteredCoins[indexPath.row]
            return CryptoTableViewCellViewModel(coin: coin)
        }
    }
    
    func detailViewModel(at indexPath: IndexPath) -> (DetailCoinViewControllerViewModelProtocol) {
        if searchTextIsEmpty {
            let coin = coins[indexPath.row]
            return DetailCoinViewControllerViewModel(coin: coin)
        }else {
            let coin = filteredCoins[indexPath.row]
            return DetailCoinViewControllerViewModel(coin: coin)
        }
    }
    
    func filterCoinsForSearchText(searchText: String) {
        searchTextIsEmpty = searchText.isEmpty
        filteredCoins = coins.filter({ coin in
            coin.name.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async { [unowned self] in
            viewModelDidChange?()
        }
    }
}
