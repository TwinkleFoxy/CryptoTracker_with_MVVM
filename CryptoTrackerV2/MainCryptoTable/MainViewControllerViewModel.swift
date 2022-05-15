//
//  MainViewControllerViewModel.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 14.05.2022.
//

import Foundation

protocol MainViewControllerViewModelProtocol: AnyObject {
    var coins: [Coin] { get }
    func featchData(complition: @escaping () -> ())
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewControllerViewModelProtocol
}

class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    var coins: [Coin] = []
    
    func featchData(complition: @escaping () -> ()) {
        NetworkManager.shared.fetchData { [unowned self] coins in
            self.coins = coins
            complition()
        }
    }
    
    func numberOfRows() -> Int {
        print(coins.count)
        return coins.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CryptoTableViewCellViewModelProtocol {
        let coin = coins[indexPath.row]
        return CryptoTableViewCellViewModel(coin: coin)
    }
    
    func detailViewModel(at indexPath: IndexPath) -> DetailCoinViewControllerViewModelProtocol {
        let coin = coins[indexPath.row]
        return DetailCoinViewControllerViewModel(coin: coin)
    }
}
