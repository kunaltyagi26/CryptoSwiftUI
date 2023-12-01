//
//  HapticsManager.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 30/11/23.
//

import Foundation
import SwiftUI

class HapticsManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
