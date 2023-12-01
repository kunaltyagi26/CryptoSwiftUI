//
//  PortfolioViewModel.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 29/11/23.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    var databaseService = DatabaseService.shared
    
    func updatePortfolio(coin: Coin, amount: Double) {
        databaseService.updatePortfolio(coin: coin, amount: amount)
    }
}
