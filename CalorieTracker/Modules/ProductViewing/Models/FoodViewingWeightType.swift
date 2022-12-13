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
            return "Ounce"
        case .gram:
            return "Gram"
        case .piece:
            return "Piece"
        }
    }
}
