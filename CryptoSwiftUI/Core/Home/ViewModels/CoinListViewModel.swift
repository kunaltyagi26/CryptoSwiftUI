//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import Combine
import Foundation

class CoinListViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var searchText = ""
    
    private let dataService = DataService<[Coin]>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        dataService.getData(for: .getCoins)
        
        $searchText
            .combineLatest(dataService.$result)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &cancellables)
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
}
