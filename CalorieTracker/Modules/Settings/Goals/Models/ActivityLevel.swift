//
//  ActivityLevel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

enum ActivityLevel: Codable {
    case low
    case moderate
    case high
    case veryHigh
}

extension ActivityLevel: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .low:
            return "Low"
        case .moderate:
            return "Moderate"
        case .high:
            return "High"
        case .veryHigh:
            return "Very High"
        }
    }
}

extension ActivityLevel: WithGetImageProtocol {
    func getImage() -> UIImage? {
        return nil
    }
}
