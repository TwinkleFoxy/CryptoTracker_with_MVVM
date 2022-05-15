//
//  Model.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 13.05.2022.
//

import Foundation

struct Coin: Codable {
    
    let id: String
    let symbol: String
    let name: String
    let image: URL
    let current_price: Double
    let market_cap: Int
    let circulating_supply: Double?
    let max_supply: Double?
    let high_24h: Double
    let low_24h: Double
    let price_change_24h: Double
    let price_change_percentage_24h: Double

}
