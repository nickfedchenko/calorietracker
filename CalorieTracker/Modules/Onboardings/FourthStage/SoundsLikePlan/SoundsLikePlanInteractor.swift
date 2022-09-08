//
//  SoundsLikePlanInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SoundsLikePlanInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class SoundsLikePlanInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: SoundsLikePlanPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - SoundsLikePlanInteractorInterface

extension SoundsLikePlanInteractor: SoundsLikePlanInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
