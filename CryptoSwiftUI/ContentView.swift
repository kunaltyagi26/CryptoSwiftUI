//
//  ContentView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
