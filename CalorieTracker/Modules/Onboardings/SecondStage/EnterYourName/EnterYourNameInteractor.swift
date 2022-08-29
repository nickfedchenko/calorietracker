//
//  EnterYourNameInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import Foundation

protocol EnterYourNameInteractorInterface: AnyObject {
    func set(enterYourName: String)
}

class EnterYourNameInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: EnterYourNamePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - EnterYourNameInteractorInterface

extension EnterYourNameInteractor: EnterYourNameInteractorInterface {
    func set(enterYourName: String) {
        onboardingManager.set(enterYourName: enterYourName)
    }
}
