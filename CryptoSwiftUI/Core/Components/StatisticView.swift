//
//  StatisticView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 27/11/23.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            if let percentageChange = stat.percentageChange {
                HStack {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(percentageChange >= 0 ? .zero : .degrees(180))
                    
                    Text(percentageChange.asPercentage())
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(percentageChange >= 0 ? Color.theme.green : Color.theme.red)
            }
        }
    }
}

#Preview {
    StatisticView(stat: Statistic.mockStat)
}
