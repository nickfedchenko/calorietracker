//
//  DateOfBirthInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation

protocol DateOfBirthInteractorInterface: AnyObject {
    func set(dateOfBirth: Date)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class DateOfBirthInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: DateOfBirthPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - DateOfBirthInteractorInterface

extension DateOfBirthInteractor: DateOfBirthInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(dateOfBirth: Date) {
        onboardingManager.set(dateOfBirth: dateOfBirth)
    }
}
