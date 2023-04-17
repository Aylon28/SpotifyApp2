//
//  HapticsManager.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 13.04.23.
//

import Foundation
import UIKit

struct HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
