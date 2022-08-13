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
    func featchData(complition: @escaping (_ internetStatus: Bool) -> ())
    func updateCoinData(complition: @escaping (_ internetStatus: Bool) -> ())
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewViewModelProtocol
    func filterCoinsForSearchText(searchText: String)
}

class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    private var searchTextIsEmpty = true
    
    var viewModelDidChange: (() -> ())?
    
    func updateCoinData(complition: @escaping (_ internetStatus: Bool) -> ()) {
        NetworkManager.shared.fetchData { coins, internetStatus  in
            internetStatus ? CacheData.shared.setCoins(coins: coins) : print("No internet connection")
            DispatchQueue.main.async {
                complition(internetStatus)
            }
        }
    }
    
    func featchData(complition: @escaping (_ internetStatus: Bool) -> ()) {
        if CacheData.shared.coinsIsEmpty() {
            updateCoinData {internetStatus in
                complition(internetStatus)
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
    
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewViewModelProtocol {
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
