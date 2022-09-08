//
//  CurrentLifestileInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol CurrentLifestileInteractorInterface: AnyObject {
    func getAllCurrentLifestile() -> [CurrentLifestile]
    func set(currentLifestile: CurrentLifestile)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class CurrentLifestileInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: CurrentLifestilePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - CurrentLifestileInteractorInterface

extension CurrentLifestileInteractor: CurrentLifestileInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllCurrentLifestile() -> [CurrentLifestile] {
        return onboardingManager.getAllCurrentLifestile()
    }
    
    func set(currentLifestile: CurrentLifestile) {
        onboardingManager.set(currentLifestile: currentLifestile)
    }
}
