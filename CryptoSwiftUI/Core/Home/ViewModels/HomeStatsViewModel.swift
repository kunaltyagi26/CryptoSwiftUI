//
//  HomeStatsViewModel.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 27/11/23.
//

import Combine
import Foundation

class HomeStatsViewModel: ObservableObject {
    @Published var stats = [Statistic]()
    
    private let dataService = DataService<GlobalData>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        downloadStats()
    }
    
    private func downloadStats() {
        dataService.getData(for: .getMarketData)
        
        dataService.$result
            .compactMap({ globalData -> MarketData? in
                globalData?.data
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { marketData in
                let marketCap = Statistic(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
                let volume = Statistic(title: "24h Volume", value: marketData.volume)
                let btcDominance = Statistic(title: "BTC Dominance", value: marketData.btcDominance)
                let portfolioValue = Statistic(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                
                self.stats = [marketCap, volume, btcDominance, portfolioValue]
            })
            .store(in: &cancellables)
    }
}
