//
//  IncreasingYourActivityLevelInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol IncreasingYourActivityLevelInteractorInterface: AnyObject {
    func set(increasingYourActivityLevel: Bool)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class IncreasingYourActivityLevelInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: IncreasingYourActivityLevelPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - IncreasingYourActivityLevelInteractorInterface

extension IncreasingYourActivityLevelInteractor: IncreasingYourActivityLevelInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(increasingYourActivityLevel: Bool) {
        onboardingManager.set(increasingYourActivityLevel: increasingYourActivityLevel)
    }
}
