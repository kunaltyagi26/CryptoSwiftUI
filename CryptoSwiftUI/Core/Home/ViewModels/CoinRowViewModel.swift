//
//  CoinRowViewModel.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import Combine
import Foundation
import SwiftUI

class CoinRowViewModel: ObservableObject {
    private let coin: Coin
    private var cancellables = Set<AnyCancellable>()
    private let imageManager = ImageManager()
    let dataService = DataService<Data>()
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    init(coin: Coin) {
        self.coin = coin
        downloadImage()
    }
    
    var rank: String {
        "\(coin.rank)."
    }
    
    var symbol: String {
        coin.symbol.uppercased()
    }
    
    var currentHoldings: String {
        coin.currentHoldings?.asString() ?? "0.00"
    }
    
    var currentHoldingsValue: String {
        coin.currentHoldingsValue.asCurrency() ?? "$0.00"
    }
    
    var currentPrice: String {
        coin.currentPrice.asCurrency() ?? "$0.00"
    }
    
    var priceChangePercentage: String {
        coin.priceChangePercentage24H?.asPercentage() ?? "0.00%"
    }
    
    var priceChangeColor: Color {
        coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red
    }
    
    private func downloadImage() {
        isLoading = true
        imageManager.loadImageUsingCache(withURLString: coin.image)
        imageManager.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
            self?.image = image
            self?.isLoading = false
        }
        .store(in: &cancellables)
    }
}
