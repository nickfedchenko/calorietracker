//
//  DifficultyOfMakingHealthyChoicesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol DifficultyOfMakingHealthyChoicesInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class DifficultyOfMakingHealthyChoicesInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: DifficultyOfMakingHealthyChoicesPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension DifficultyOfMakingHealthyChoicesInteractor: DifficultyOfMakingHealthyChoicesInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
