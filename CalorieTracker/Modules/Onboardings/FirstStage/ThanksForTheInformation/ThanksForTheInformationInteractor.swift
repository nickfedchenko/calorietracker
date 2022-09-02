//
//  ThanksForTheInformationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ThanksForTheInformationInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ThanksForTheInformationInteractor {
    
    // MARK: - Public properties

    weak var presenter: ThanksForTheInformationPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - ThanksForTheInformationInteractorInterface

extension ThanksForTheInformationInteractor: ThanksForTheInformationInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
