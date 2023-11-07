//
//  CoinRowView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct CoinRowView: View {
    let showHoldingsColumn: Bool
    
    @ObservedObject var coinVM: CoinRowViewModel
    
    init(showHoldingsColumn: Bool, coin: Coin) {
        self.showHoldingsColumn = showHoldingsColumn
        coinVM = CoinRowViewModel(coin: coin)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            coinColumn
            
            Spacer()
            
            if showHoldingsColumn {
                holdingColumn
                Spacer()
            }
            
            currentPriceColumn
        }
        .font(.subheadline)
        .padding()
        .background {
            Color(uiColor: UIColor.systemGray6)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private extension CoinRowView {
    var coinColumn: some View {
        HStack(spacing: 0) {
            Text(coinVM.rank)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .padding(.trailing)
            
            coinImage
            
            Text(coinVM.symbol)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .padding(.leading, 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var holdingColumn: some View {
        VStack(alignment: .trailing) {
            Text(coinVM.currentHoldingsValue)
                    .bold()
            
            Text(coinVM.currentHoldings)
        }
        .foregroundStyle(Color.theme.accent)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var currentPriceColumn: some View {
        VStack(alignment: .trailing) {
            Text(coinVM.currentPrice)
                .bold()
                .foregroundStyle(Color.theme.accent)

            Text(coinVM.priceChangePercentage)
                .foregroundStyle(
                    coinVM.priceChangeColor
                )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

extension CoinRowView {
    var coinImage: some View {
        ZStack {
            if let coinImage = coinVM.image {
                Image(uiImage: coinImage)
                    .resizable()
            } else if coinVM.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    CoinRowView(
        showHoldingsColumn: true,
        coin: Coin.mockCoin
    )
}
