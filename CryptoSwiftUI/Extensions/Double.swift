//
//  Double.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import Foundation

extension Double {
    /// Converts double to currency as a string with 2-6 decimal places.
    /// - Returns: String
    func asCurrency() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en-US")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(for: self)
    }
    
    /// Converts double to percentage string with 2 decimal places.
    /// - Returns: String
    func asPercentage() -> String {
        return "\(String(format: "%.2f", self))%"
    }
    
    /// Converts double to string with 2 decimal places.
    /// - Returns: String
    func asString() -> String {
        return "\(String(format: "%.2f", self))"
    }
}
