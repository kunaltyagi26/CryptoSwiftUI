//
//  HomeView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio = false
    @State private var showPortfolioView = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                HomeHeaderView(showPortfolio: $showPortfolio, showPortfolioView: $showPortfolioView)
                    .padding(.horizontal)
                
                Spacer()
                
                HomeStatsView(showPortfolio: showPortfolio)
                    .frame(height: 60)
                    .padding(.top)
                
                if !showPortfolio {
                    CoinListView(showPortfolio: $showPortfolio, showPortfolioView: $showPortfolioView)
                        .transition(.move(edge: .leading))
                } else {
                    CoinListView(showPortfolio: $showPortfolio, showPortfolioView: $showPortfolioView)
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
