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
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asString()

        default:
            return "\(sign)\(self)"
        }
    }
}
