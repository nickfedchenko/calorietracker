//
//  TimeToSeeYourGoalWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol TimeToSeeYourGoalWeightInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class TimeToSeeYourGoalWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: TimeToSeeYourGoalWeightPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - TimeToSeeYourGoalWeightInteractorInterface

extension TimeToSeeYourGoalWeightInteractor: TimeToSeeYourGoalWeightInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
