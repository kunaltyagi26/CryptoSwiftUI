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
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView = false
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $coinListVM.searchText)
            
            header
                .padding()
            
            if showPortfolio {
                VStack {
                    if coinListVM.portfolioCoins.count == 0 {
                        portfolioEmptyView
                    } else {
                        List(coinListVM.portfolioCoins) { coin in
                            CoinRowView(showHoldingsColumn: showPortfolio, coin: coin)
                                .listRowInsets(.init(top: 0, leading: 6, bottom: 10, trailing: 6))
                                .onTapGesture {
                                    segue(coin: coin)
                                }
                                .listRowBackground(Color.theme.background)
                        }
                        .listStyle(.plain)
                    }
                }
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView(coins: coinListVM.coins, searchText: $coinListVM.searchText)
                })
            } else if coinListVM.coins.count != 0 {
                VStack {
                    List(coinListVM.coins) { coin in
                        CoinRowView(showHoldingsColumn: showPortfolio, coin: coin)
                            .listRowInsets(.init(top: 0, leading: 6, bottom: 10, trailing: 6))
                            .onTapGesture {
                                segue(coin: coin)
                            }
                            .listRowBackground(Color.theme.background)
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
        .navigationDestination(isPresented: $showDetailView, destination: {
            if let selectedCoin = selectedCoin {
                DetailView(coin: selectedCoin)
            }
        })
        .background {
            Color.theme.background
        }
    }
}

private extension CoinListView {
    private var header: some View {
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
            .rotationEffect(coinListVM.isLoading ? .degrees(360) : .zero, anchor: .center)
            
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
    
    private var portfolioEmptyView: some View {
        VStack {
            Spacer()
            
            Text("You haven't added any coins to the portfolio yet! Click the + button to get started.")
                .font(.callout)
                .foregroundStyle(Color.theme.accent)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(50)
            
            Spacer()
        }
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

#Preview {
    CoinListView(showPortfolio: .constant(true), showPortfolioView: .constant(false))
}
