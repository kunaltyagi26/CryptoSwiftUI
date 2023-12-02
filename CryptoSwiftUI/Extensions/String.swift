//
//  String.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 01/12/23.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
