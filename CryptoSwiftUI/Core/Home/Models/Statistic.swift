//
//  Statistic.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 27/11/23.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

extension Statistic {
    static var mockStat = Statistic(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34)
}
