//
//  CallToAchieveGoalInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CallToAchieveGoalInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class CallToAchieveGoalInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: CallToAchieveGoalPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - CallToAchieveGoalInteractorInterface

extension CallToAchieveGoalInteractor: CallToAchieveGoalInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
