//
//  PresenceOfAllergiesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol PresenceOfAllergiesInteractorInterface: AnyObject {
    func getAllPresenceOfAllergies() -> [PresenceOfAllergies]
    func set(presenceOfAllergies: PresenceOfAllergies)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class PresenceOfAllergiesInteractor {
    // MARK: - Public properties
    
    weak var presenter: PresenceOfAllergiesPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - PresenceOfAllergiesInteractorInterface

extension PresenceOfAllergiesInteractor: PresenceOfAllergiesInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllPresenceOfAllergies() -> [PresenceOfAllergies] {
        return onboardingManager.getAllPresenceOfAllergies()
    }
    
    func set(presenceOfAllergies: PresenceOfAllergies) {
        onboardingManager.set(presenceOfAllergies: presenceOfAllergies)
    }
}
