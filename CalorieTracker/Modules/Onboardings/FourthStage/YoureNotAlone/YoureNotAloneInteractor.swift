//
//  YoureNotAloneInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol YoureNotAloneInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class YoureNotAloneInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: YoureNotAlonePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - YoureNotAloneInteractorInterface

extension YoureNotAloneInteractor: YoureNotAloneInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
