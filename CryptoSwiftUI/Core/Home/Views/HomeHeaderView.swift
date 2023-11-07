//
//  HomeHeaderView.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct HomeHeaderView: View {
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            CircleButtonView(
                iconName: showPortfolio ? "plus" : "info"
            )
            .background {
                CircleButtonAnimationView(animate: $showPortfolio)
                    .frame(width: 65, height: 65)
            }
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(
                    Angle(degrees: showPortfolio ? 180 : 0)
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
}

#Preview {
    HomeHeaderView(showPortfolio: .constant(false))
}
