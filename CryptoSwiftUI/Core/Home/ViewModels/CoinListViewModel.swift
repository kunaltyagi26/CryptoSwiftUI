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
    
    private let dataService = DataService<[Coin]>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        dataService.getData(for: .getCoins)
        dataService.$result.sink { [weak self] coins in
            if let coins = coins {
                self?.coins = coins
            }
        }
        .store(in: &cancellables)
    }
}
