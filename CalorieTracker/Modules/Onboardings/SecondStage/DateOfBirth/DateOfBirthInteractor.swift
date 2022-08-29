//
//  DateOfBirthInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation

protocol DateOfBirthInteractorInterface: AnyObject {}

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

extension DateOfBirthInteractor: DateOfBirthInteractorInterface {}
