//
//  ThoughtsOnStressEatingInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol ThoughtsOnStressEatingInteractorInterface: AnyObject {
    func set(thoughtsOnStressEating: Bool)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ThoughtsOnStressEatingInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: ThoughtsOnStressEatingPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
        
    }
}

// MARK: - ThoughtsOnStressEatingInteractorInterface

extension ThoughtsOnStressEatingInteractor: ThoughtsOnStressEatingInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(thoughtsOnStressEating: Bool) {
        onboardingManager.set(thoughtsOnStressEating: thoughtsOnStressEating)
    }
}
