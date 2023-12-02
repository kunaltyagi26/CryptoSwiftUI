//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 01/12/23.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var detailVM: DetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        self.detailVM = DetailViewModel(coin: coin)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 150)
                
                overviewTitle
                
                Divider()
                
                overviewGrid
                
                additionalInfoTitle
                
                Divider()
                
                additionalInfoGrid
            }
        }
        .navigationTitle(detailVM.coin.name)
        .padding()
    }
}

extension DetailView {
    var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, content: {
            ForEach(detailVM.overviewStatistics) {
                StatisticView(stat: $0)
            }
        })
    }
    
    var additionalInfoTitle: some View {
        Text("Additional Information")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var additionalInfoGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, content: {
            ForEach(detailVM.additionalStatistics) {
                StatisticView(stat: $0)
            }
        })
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: Coin.mockCoin)
    }
}
