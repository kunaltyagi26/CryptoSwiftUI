//
//  CircleButton.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 07/11/23.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .frame(width: 40, height: 40)
        .background {
            Circle()
                .foregroundColor(Color.theme.background)
        }
        .shadow(
            color: Color.theme.accent.opacity(0.3),
            radius: 10
        )
        .contentShape(Circle())
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "swift")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
