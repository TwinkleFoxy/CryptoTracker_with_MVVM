//
//  CachData.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 05.07.2022.
//

import Foundation

class CacheData {
    static let shared = CacheData()
    
    private var coins: [Coin] = []
    private var favouriteCoins: [Coin] = []
    private var filteredCoins: [Coin] = []
    private var searchText = ""
    
    private init() {
        
    }
    
    //MARK: - Work with coins
    func setCoins(coins: [Coin]) {
        self.coins = coins
    }
    
    func getCoins() -> [Coin] {
        return coins
    }
    
    func countCoins() -> Int {
        return coins.count
    }
    
    func getCoin(at indexPath: IndexPath) -> Coin{
        return coins[indexPath.row]
    }
    
    func coinsIsEmpty() -> Bool {
        return coins.isEmpty
    }
    
    //MARK: - Work with favourite coins
    func setFavouriteCoins() {
        favouriteCoins.removeAll()
        coins.forEach { coin in
            if DataManager.shared.getFavoriteStatus(for: coin.name) {
                favouriteCoins.append(coin)
            }
        }
    }
    
    func getFavouriteCoins() -> [Coin] {
        return favouriteCoins
    }
    
    func countFavouriteCoins() -> Int {
        return favouriteCoins.count
    }
    
    func getFavouriteCoin(at indexPath: IndexPath) -> Coin{
        return favouriteCoins[indexPath.row]
    }

    
    //MARK: - Work with filtered coins
    func setFilteredCoins(filteredCoins: [Coin]) {
        self.filteredCoins = filteredCoins
    }
    
    func getFilteredCoins() -> [Coin] {
        return filteredCoins
    }
    
    func countFilteredCoins() -> Int {
        return filteredCoins.count
    }
    
    func getFilteredCoin(at indexPath: IndexPath) -> Coin{
        return filteredCoins[indexPath.row]
    }
    
    //MARK: - Work with search text
    func setSearchText(searchText: String) {
        self.searchText = searchText
    }
    
    func getSearchText() -> String {
        return searchText
    }
}
