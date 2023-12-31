//
//  CryptoSwiftUIApp.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.accent)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.accent)
        ]
        
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
