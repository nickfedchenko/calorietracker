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
            return R.string.localizable.low()
        case .moderate:
            return R.string.localizable.moderate()
        case .high:
            return R.string.localizable.high()
        case .veryHigh:
            return R.string.localizable.veryHigh()
        }
    }
}

extension ActivityLevel: WithGetImageProtocol, WithGetDescriptionProtocol {
    func getImage() -> UIImage? {
        return nil
    }
    
    func getDescription() -> NSAttributedString? {
        return nil
    }
}
