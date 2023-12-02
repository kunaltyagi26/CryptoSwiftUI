//
//  DetailViewModel.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 01/12/23.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
    private let dataservice = DataService<CoinDetail>()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var coin: Coin
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    
    init(coin: Coin) {
        self.coin = coin
        
        dataservice.getData(for: .getCoinDetail(id: coin.id))
        
        addSubscriber()
    }
    
    private func addSubscriber() {
        dataservice.$result
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            })
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let overview = getOverviewStatistics(coin: coin)
        let additional = getAdditionalInfoStatistics(coin: coin, coinDetail: coinDetail)
        
        return(overview, additional)
    }
    
    private func getOverviewStatistics(coin: Coin) -> [Statistic] {
        let price = coin.currentPrice.asCurrency() ?? ""
        let priceChangePercentage = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: priceChangePercentage)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChangePercentage)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        return [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ]
    }
    
    private func getAdditionalInfoStatistics(coin: Coin, coinDetail: CoinDetail?) -> [Statistic] {
        let high = coin.high24H?.asCurrency() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrency() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrency() ?? "n/a"
        let priceChangePercentage = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: priceChangePercentage)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "Market Cap Change", value: marketCapChange, percentageChange: marketCapChangePercentage)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        return [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat,
            blockTimeStat,
            hashingStat
        ]
    }
}
