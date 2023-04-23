//
//  FoodViewingWeightType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import Foundation

enum FoodViewingWeightType: WithGetTitleProtocol, CaseIterable {
    case gram
    case mL
    
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .mL:
            return R.string.localizable.measurementMl()
        case .gram:
            return R.string.localizable.gram()
        }
    }
}
