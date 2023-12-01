//
//  CoinImageView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 28/11/23.
//

import SwiftUI

struct CoinImageView: View {
    @ObservedObject var coinVM: CoinRowViewModel
    
    var body: some View {
        ZStack {
            if let coinImage = coinVM.image {
                Image(uiImage: coinImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if coinVM.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coinVM: CoinRowViewModel(coin: Coin.mockCoin))
}
