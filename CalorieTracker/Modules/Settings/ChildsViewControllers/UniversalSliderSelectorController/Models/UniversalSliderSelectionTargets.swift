//
//  UniversalSliderSelectionTargets.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 03.03.2023.
//

import UIKit

enum UniversalSliderSelectionTargets {
    case weeklyGoal(numberOfAnchors: Double, lowerBoundValue: Double, upperBoundValue: Double)
    case activityLevel(numberOfAnchors: Double, lowerBoundValue: Double, upperBoundValue: Double)
    
    var leftTitle: NSAttributedString {
        switch self {
        case .weeklyGoal:
            return NSAttributedString(
                string: R.string.localizable.settingsGoalActivityLevel(),
                attributes: [
                    .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                    .foregroundColor: UIColor(hex: "192621")
                ]
            )
        case .activityLevel:
            return NSAttributedString(
                string: R.string.localizable.settingsGoalWeekly(),
                attributes: [
                    .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                    .foregroundColor: UIColor(hex: "192621")
                ]
            )
        }
    }
}
