//
//  CoinListView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import SwiftUI

struct CoinListView: View {
    @Binding var showPortfolio: Bool
    @ObservedObject var coinListVM = CoinListViewModel()
    
    var body: some View {
        if coinListVM.coins.count != 0 {
            VStack {
                HomeStatsView(showPortfolio: showPortfolio)
                    .frame(height: 60)
                    .padding(.top)
                
                SearchBarView(searchText: $coinListVM.searchText)
                
                header
                    .padding()
                
                List(coinListVM.coins) { coin in
                    CoinRowView(showHoldingsColumn: showPortfolio, coin: coin)
                        .listRowInsets(.init(top: 0, leading: 6, bottom: 10, trailing: 6))
                }
                .listStyle(.plain)
            }
        } else {
            VStack {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            }
            
        }
    }
}

private extension CoinListView {
    var header: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Spacer()
            
            Text("Coin")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 50)
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "arrow.down")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "arrow.down")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
}

#Preview {
    CoinListView(showPortfolio: .constant(true))
}
