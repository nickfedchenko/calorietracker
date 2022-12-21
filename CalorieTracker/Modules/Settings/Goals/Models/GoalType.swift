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
            return "Lose Weight"
        case .buildMuscle:
            return "Build Muscle"
        case .maintainWeight:
            return "Maintain Weight"
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
