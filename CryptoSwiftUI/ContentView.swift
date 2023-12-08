//
//  ContentView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showLaunchView = true
    var body: some View {
        ZStack {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            
            ZStack {
                if showLaunchView {
                    LaunchView(showLaunchView: $showLaunchView)
                        .transition(.move(edge: .leading))
                }
            }
            .zIndex(2.0)
        }
    }
}

#Preview {
    ContentView()
}
