//
//  HomeStatsView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 27/11/23.
//

import SwiftUI

struct HomeStatsView: View {
    @ObservedObject var vm = HomeStatsViewModel()
    var showPortfolio: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top) {
                ForEach(vm.stats) { stat in
                    StatisticView(stat: stat)
                        .frame(width: geometry.size.width / 3)
                }
            }
            .frame(width: geometry.size.width, alignment: showPortfolio ? .trailing : .leading)
        }
    }
}

#Preview {
    HomeStatsView(showPortfolio: false)
}
