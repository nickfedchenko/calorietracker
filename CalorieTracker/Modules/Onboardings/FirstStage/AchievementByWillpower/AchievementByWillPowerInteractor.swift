//
//  AchievementByWillpowerInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillPowerInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class AchievementByWillPowerInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: AchievementByWillPowerPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - AchievementByWillPowerInteractorInterface

extension AchievementByWillPowerInteractor: AchievementByWillPowerInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
