//
//  SoundsGoodInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SoundsGoodInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class SoundsGoodInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: SoundsGoodPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - SoundsGoodInteractorInterface

extension SoundsGoodInteractor: SoundsGoodInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
