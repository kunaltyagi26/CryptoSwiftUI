//
//  URLConstants.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 09/11/23.
//

import Foundation

struct URLConstants {
    private static var apiKey = "CG-ec3d7btNsYg46Hp9WkGe81Pb"
    
    static var getCoins = "https://api.coingecko.com/api/v3/coins/markets?x_cg_demo_api_key=\(apiKey)&vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    static var getMarketData = "https://api.coingecko.com/api/v3/global?x_cg_demo_api_key=\(apiKey)"
    
    static func getCoinDetail(id: String) -> String {
        "https://api.coingecko.com/api/v3/coins/\(id)?x_cg_demo_api_key=\(apiKey)&localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    }
}
