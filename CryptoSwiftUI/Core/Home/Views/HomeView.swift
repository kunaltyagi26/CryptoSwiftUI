//
//  HomeView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                HomeHeaderView(showPortfolio: $showPortfolio)
                .padding(.horizontal)
                
                Spacer()
                
                if !showPortfolio {
                    CoinListView(showPortfolio: $showPortfolio)
                        .transition(.move(edge: .leading))
                } else {
                    CoinListView(showPortfolio: $showPortfolio)
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
