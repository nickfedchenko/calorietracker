//
//  FoodViewingWeightType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import Foundation

enum FoodViewingWeightType: WithGetTitleProtocol, CaseIterable {
    case ounce
    case gram
    case piece
    
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .ounce:
            return R.string.localizable.ounce()
        case .gram:
            return R.string.localizable.gram()
        case .piece:
            return R.string.localizable.piece()
        }
    }
}
