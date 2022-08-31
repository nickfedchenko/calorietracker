//
//  RepresentationOfIncreasedActivityLevelsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

// swiftlint:disable line_length


protocol RepresentationOfIncreasedActivityLevelsInteractorInterface: AnyObject {
    func set(representationOfIncreasedActivityLevels: Bool)
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

extension RepresentationOfIncreasedActivityLevelsInteractor: RepresentationOfIncreasedActivityLevelsInteractorInterface {
    func set(representationOfIncreasedActivityLevels: Bool) {
        onboardingManager.set(representationOfIncreasedActivityLevels: representationOfIncreasedActivityLevels)
    }
}
