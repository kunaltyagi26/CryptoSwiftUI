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
    private var databaseService = DatabaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        downloadStats()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func downloadStats() {
        dataService.getData(for: .getMarketData)
        
        databaseService.$savedEntites
            .combineLatest(dataService.$result)
            .compactMap { (portfolio, globalData) -> [Statistic] in
                guard let marketData = globalData?.data else {
                    return []
                }
                
                let portfolioValue = portfolio.reduce(0) { partialResult, portfolio in
                    partialResult + (portfolio.amount * portfolio.price)
                }
                
                let previousValue = portfolio
                    .map { (coin) -> Double in
                        let currentValue = (coin.amount * coin.price)
                        let percentChange = coin.priceChangePercentage / 100
                        let previousValue = currentValue / (1 + percentChange)
                        return previousValue
                    }
                    .reduce(0, +)

                let percentageChange = ((portfolioValue - previousValue) / previousValue)
                
                let marketCap = Statistic(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
                let volume = Statistic(title: "24h Volume", value: marketData.volume)
                let btcDominance = Statistic(title: "BTC Dominance", value: marketData.btcDominance)
                let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrency() ?? "$0.00", percentageChange: percentageChange)
                
                return [marketCap, volume, btcDominance, portfolio]
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] statistics in
                self?.stats = statistics
            }
            .store(in: &cancellables)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "refreshData"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.downloadStats()
        }
    }
}
