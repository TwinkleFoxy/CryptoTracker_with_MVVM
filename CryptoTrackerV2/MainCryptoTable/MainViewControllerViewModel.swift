//
//  MainViewControllerViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 14.05.2022.
//

import Foundation
import UIKit

protocol MainViewControllerViewModelProtocol: AnyObject {
    var coins: [Coin] { get }
    var filteredCoins: [Coin] { get }
    var searchTextIsEmpty: Bool { get }
    var viewModelDidChange: ((MainViewControllerViewModelProtocol) -> ())? { get set }
    func featchData(complition: @escaping () -> ())
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewControllerViewModelProtocol
    func filterCoinsForSearchText(searchText: String)
}

class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    internal var coins: [Coin] = []
    internal var filteredCoins: [Coin] = []
    internal var searchTextIsEmpty = true
    
    var viewModelDidChange: ((MainViewControllerViewModelProtocol) -> ())?
    
    func featchData(complition: @escaping () -> ()) {
        NetworkManager.shared.fetchData { [unowned self] coins in
            self.coins = coins
            DispatchQueue.main.async {
                complition()
            }
        }
    }
    
    func numberOfRows() -> Int {
        searchTextIsEmpty ? coins.count : filteredCoins.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol {
        if searchTextIsEmpty {
            let coin = coins[indexPath.row]
            return CryptoTableViewCellViewModel(coin: coin)
        } else {
            let coin = filteredCoins[indexPath.row]
            return CryptoTableViewCellViewModel(coin: coin)
        }
    }
    
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewControllerViewModelProtocol {
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
            return coin.name.lowercased().contains(searchText.lowercased())
        })
        viewModelDidChange?(self)
    }
}
