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
                    CoinListView(showPortfolio: true)
                        .transition(.move(edge: .leading))
                } else {
                    CoinListView(showPortfolio: false)
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
