//
//  AllergicRestrictionsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol AllergicRestrictionsInteractorInterface: AnyObject {
    func getAllAllergicRestrictions() -> [AllergicRestrictions]
    func set(allergicRestrictions: AllergicRestrictions)
}

class AllergicRestrictionsInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: AllergicRestrictionsPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - AllergicRestrictionsInteractorInterface

extension AllergicRestrictionsInteractor: AllergicRestrictionsInteractorInterface {
    func getAllAllergicRestrictions() -> [AllergicRestrictions] {
        return onboardingManager.getAllAllergicRestrictions()
    }
    
    func set(allergicRestrictions: AllergicRestrictions) {
        onboardingManager.set(allergicRestrictions: allergicRestrictions)
    }
}
