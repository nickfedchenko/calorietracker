//
//  GoalType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

enum GoalType: Codable {
    case loseWeight
    case buildMuscle
    case maintainWeight
}

extension GoalType: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .loseWeight:
            return R.string.localizable.loseWeight()
        case .buildMuscle:
            return R.string.localizable.buildMuscle()
        case .maintainWeight:
            return R.string.localizable.maintainWeight()
        }
    }
}

extension GoalType: WithGetImageProtocol, WithGetDescriptionProtocol {
    func getImage() -> UIImage? {
        return nil
    }
    
    func getDescription() -> NSAttributedString? {
        return nil
    }
}
