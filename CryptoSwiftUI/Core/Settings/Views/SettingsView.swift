//
//  SettingsView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 04/12/23.
//

import SwiftUI

struct SettingsView: View {
    let defaultURL = URL(string: "https://www.google.com")
    let youtubeUrl = URL(string: "https://www.youtube.com/swiftfulthinking")
    let coinGeckoUrl = URL(string: "https://www.coingecko.com")
    let personalUrl = URL(string: "https://github.com/kunaltyagi26")
    
    var body: some View {
        NavigationStack {
            List {
                swiftfulThinkingSection
                coinGeckoSection
                developerSection
            }
            .font(.headline)
            .tint(Color(uiColor: UIColor.systemBlue))
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

extension SettingsView {
    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made by follwing @SwiftfulThinking course on Youtube. It uses MVVM architecture, Combine and Core Data!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            if let youtubeUrl = youtubeUrl {
                Link(destination: youtubeUrl) {
                    Text("Link to Youtube")
                }
            }
        } header: {
            Text("Swiftful Thinking")
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            if let coinGeckoUrl = coinGeckoUrl {
                Link(destination: coinGeckoUrl) {
                    Text("Visit CoinGecko")
                }
            }
        } header: {
            Text("CoinGecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("developer")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was developed by Kunal Tyagi. It uses SwiftUI and it is written in Swift. The project benefits from multi-threading, publisher/subscriber and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            if let personalUrl = personalUrl {
                Link(destination: personalUrl) {
                    Text("Visit Github")
                }
            }
        } header: {
            Text("Developer")
        }
    }
}

#Preview {
    SettingsView()
}
