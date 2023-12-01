//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import Combine
import Foundation

class CoinListViewModel: ObservableObject {
    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }
    
    @Published var coins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var sortOption: SortOption = .holdings
    
    private let dataService = DataService<[Coin]>()
    private(set) var databaseService = DatabaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    func reloadData() {
        isLoading = true
        dataService.getData(for: .getCoins)
        HapticsManager.notification(type: .success)
    }
    
    private func addSubscriber() {
        dataService.getData(for: .getCoins)
        
        $searchText
            .combineLatest(dataService.$result, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.isLoading = false
                self?.coins = coins
            }
            .store(in: &cancellables)
        
        $coins
            .combineLatest(databaseService.$savedEntites)
            .map { coins, portfolioEntities -> [Coin] in
                coins.compactMap { [weak self] coin -> Coin? in
                    guard let entity = portfolioEntities.first(where: { $0.id == coin.id }) else {
                        return nil
                    }
                    
                    self?.databaseService.updatePortfolio(
                        coin: coin,
                        amount: entity.amount,
                        priceChangePercentage: coin.priceChangePercentage24H ?? 0.0
                    )
                    
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] portfolioCoins in
                guard let self = self else {
                    return
                }
                
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: portfolioCoins)
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin]?, sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]?) -> [Coin] {
        guard !searchText.isEmpty,
              let coins = coins else {
            return coins ?? []
        }
        
        return coins.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.symbol.lowercased().contains(searchText.lowercased()) ||
            $0.id.lowercased().contains(searchText.lowercased())
        }
    }
    
    private func sortCoins(sortOption: SortOption, coins: inout [Coin]) {
        switch sortOption {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
}
