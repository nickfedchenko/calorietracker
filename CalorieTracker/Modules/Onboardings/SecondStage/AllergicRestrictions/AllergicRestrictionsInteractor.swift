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
    func getCurrentOnboardingStage() -> OnboardingStage
    func restrictionTapped(at index: Int)
    func saveRestrictions()
}

class AllergicRestrictionsInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: AllergicRestrictionsPresenterInterface?
    let allRestrictions: [AllergicRestrictions] = AllergicRestrictions.allCases
    var selectedRestrictions: [AllergicRestrictions] = []
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - AllergicRestrictionsInteractorInterface

extension AllergicRestrictionsInteractor: AllergicRestrictionsInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllAllergicRestrictions() -> [AllergicRestrictions] {
        return onboardingManager.getAllAllergicRestrictions()
    }
    
    func set(allergicRestrictions: AllergicRestrictions) {
        onboardingManager.set(allergicRestrictions: allergicRestrictions)
    }
    
    func restrictionTapped(at index: Int) {
        let tappedRestriction = allRestrictions[index]
            if selectedRestrictions.contains(where: { $0 == tappedRestriction }) {
                selectedRestrictions.removeAll(where: { $0 == tappedRestriction })
            } else {
                selectedRestrictions.append(tappedRestriction)
            }
    }
    
    func saveRestrictions() {
        UDM.restrictions = selectedRestrictions
    }
}
