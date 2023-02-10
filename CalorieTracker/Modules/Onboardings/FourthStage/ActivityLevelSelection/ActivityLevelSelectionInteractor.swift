//
//  ActivityLevelSelectionInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.02.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol ActivityLevelSelectionInteractorInterface: AnyObject {
    func getPossibleActivityLevels() -> [ActivityLevel]
    func set(selectedActivityLevel: ActivityLevel)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ActivityLevelSelectionInteractor {
    private let onboardingManager: OnboardingManagerInterface
    weak var presenter: ActivityLevelSelectionPresenterInterface?
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension ActivityLevelSelectionInteractor: ActivityLevelSelectionInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getPossibleActivityLevels() -> [ActivityLevel] {
        return [.low, .moderate, .high, .veryHigh]
    }
    
    func set(selectedActivityLevel: ActivityLevel) {
        onboardingManager.setActivityLevel(level: selectedActivityLevel)
    }
}
