//
//  RepresentationOfIncreasedActivityLevelsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol RepresentationOfIncreasedActivityLevelsInteractorInterface: AnyObject {
    func set(representationOfIncreasedActivityLevels: Bool)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class RepresentationOfIncreasedActivityLevelsInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: RepresentationOfIncreasedActivityLevelsPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - RepresentationOfIncreasedActivityLevelsInteractorInterface

// swiftlint:disable:next line_length
extension RepresentationOfIncreasedActivityLevelsInteractor: RepresentationOfIncreasedActivityLevelsInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(representationOfIncreasedActivityLevels: Bool) {
        onboardingManager.set(representationOfIncreasedActivityLevels: representationOfIncreasedActivityLevels)
    }
}