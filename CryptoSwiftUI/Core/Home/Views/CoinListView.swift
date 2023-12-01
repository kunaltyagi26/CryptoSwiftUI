//
//  CoinListView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import SwiftUI

struct CoinListView: View {
    @Binding var showPortfolio: Bool
    @Binding var showPortfolioView: Bool
    @ObservedObject var coinListVM = CoinListViewModel()
    
    var body: some View {
        SearchBarView(searchText: $coinListVM.searchText)
        
        header
            .padding()
        
        if showPortfolio {
            VStack {
                List(coinListVM.portfolioCoins) { coin in
                    CoinRowView(showHoldingsColumn: showPortfolio, coin: coin)
                        .listRowInsets(.init(top: 0, leading: 6, bottom: 10, trailing: 6))
                }
                .listStyle(.plain)
            }
            .sheet(isPresented: $showPortfolioView, content: {
                PortfolioView(coins: coinListVM.coins, searchText: $coinListVM.searchText)
            })
        } else if coinListVM.coins.count != 0 {
            VStack {
                List(coinListVM.coins) { coin in
                    CoinRowView(showHoldingsColumn: showPortfolio, coin: coin)
                        .listRowInsets(.init(top: 0, leading: 6, bottom: 10, trailing: 6))
                }
                .listStyle(.plain)
            }
        } else if coinListVM.searchText.isEmpty {
            VStack {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            }
        } else {
            Spacer()
        }
    }
}

private extension CoinListView {
    var header: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Spacer()
            
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        coinListVM.sortOption == .rank ||
                        coinListVM.sortOption == .rankReversed ?
                        1.0 : 0.0
                    )
                    .rotationEffect(coinListVM.sortOption == .rank ? .zero : .degrees(180))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 50)
            .onTapGesture {
                withAnimation(.default) {
                    coinListVM.sortOption = coinListVM.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            coinListVM.sortOption == .holdings ||
                            coinListVM.sortOption == .holdingsReversed ?
                            1.0 : 0.0
                        )
                        .rotationEffect(coinListVM.sortOption == .holdings ? .zero : .degrees(180))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.leading, 20)
                .onTapGesture {
                    withAnimation(.default) {
                        coinListVM.sortOption = coinListVM.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(
                        coinListVM.sortOption == .price ||
                        coinListVM.sortOption == .priceReversed ?
                        1.0 : 0.0
                    )
                    .rotationEffect(coinListVM.sortOption == .price ? .zero : .degrees(180))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    coinListVM.sortOption = coinListVM.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    coinListVM.reloadData()
                }
                NotificationCenter.default.post(Notification(name: Notification.Name("refreshData")))
            } label: {
                Image(systemName: "goforward")
            }
            .padding(.leading, 8)
            .rotationEffect(coinListVM.isLoading ? .degrees(360) : .zero)
            
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
}

#Preview {
    CoinListView(showPortfolio: .constant(true), showPortfolioView: .constant(false))
}
