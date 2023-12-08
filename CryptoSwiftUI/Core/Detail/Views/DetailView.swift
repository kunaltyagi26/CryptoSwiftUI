//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 01/12/23.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var detailVM: DetailViewModel
    @State private var showFullDescription = false
    
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
            VStack {
                ChartView(coin: detailVM.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    
                    Divider()
                    
                    descriptionSection
                    
                    overviewGrid
                    
                    additionalInfoTitle
                    
                    Divider()
                    
                    additionalInfoGrid
                    
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(detailVM.coin.name)
        .background {
            Color.theme.background
                .ignoresSafeArea()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem
            }
        })
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, content: {
            ForEach(detailVM.overviewStatistics) {
                StatisticView(stat: $0)
            }
        })
    }
    
    private var additionalInfoTitle: some View {
        Text("Additional Information")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalInfoGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, content: {
            ForEach(detailVM.additionalStatistics) {
                StatisticView(stat: $0)
            }
        })
    }
    
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(detailVM.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(
                coinVM: CoinRowViewModel(
                    coin: detailVM.coin
                )
            )
            .frame(width: 25, height: 25)
        }
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let description = detailVM.coinDescription,
               !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.smooth) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Read Less" : "Read More")
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 2)
                    }
                    .tint(
                        Color(
                            uiColor: UIColor.systemBlue
                        )
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteUrlString = detailVM.websiteUrl,
               let websiteUrl = URL(string: websiteUrlString) {
                Link("Website", destination: websiteUrl)
            }
            
            if let websiteUrlString = detailVM.redditUrl,
               let websiteUrl = URL(string: websiteUrlString) {
                Link("Reddit", destination: websiteUrl)
            }
        }
        .tint(
            Color(
                uiColor: UIColor.systemBlue
            )
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: Coin.mockCoin)
    }
}
