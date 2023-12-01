//
//  PortfolioView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 28/11/23.
//

import SwiftUI

struct PortfolioView: View {
    var coins: [Coin]
    var portfolioVM = PortfolioViewModel()
    
    @Binding var searchText: String
    
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText = ""
    @State private var showCheckmark = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
                .font(.headline)
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .opacity(showCheckmark ? 1.0 : 0.0)
                        
                        Text("SAVE")
                            .opacity(selectedCoin != nil && !quantityText.isEmpty &&  selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
                            .onTapGesture {
                                saveButtonPressed()
                            }
                    }
                    .font(.headline)
                }
            })
            .onChange(of: searchText) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(coins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                                    lineWidth: 1.0
                                )
                        }
                }
            }
            .padding()
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                
                Spacer()
                
                Text(selectedCoin?.currentPrice.asCurrency() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                
                Spacer()
                
                TextField("Eg. 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                
                Spacer()
                
                Text(getCurrentValue().asCurrency() ?? "")
            }
        }
        .padding()
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        
        if let savedCoin = portfolioVM.databaseService.savedEntites.filter({ $0.id == coin.id }).first {
            selectedCoin = coin.updateHoldings(amount: savedCoin.amount)
            quantityText = "\(savedCoin.amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
        let amount = Double(quantityText) else {
            return
        }
        
        portfolioVM.updatePortfolio(coin: coin, amount: amount)
                
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        hideKeyboard()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
        
    private func removeSelectedCoin() {
        selectedCoin = nil
        searchText = ""
    }
}

#Preview {
    PortfolioView(coins: [Coin.mockCoin], searchText: .constant(""))
}
