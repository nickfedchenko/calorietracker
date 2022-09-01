//
//  PurposeOfTheParishInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
    func getAllPurposeOfTheParish() -> [PurposeOfTheParish]
    func set(purposeOfTheParish: PurposeOfTheParish)
}

class PurposeOfTheParishInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: PurposeOfTheParishPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - PurposeOfTheParishInteractorInterface

extension PurposeOfTheParishInteractor: PurposeOfTheParishInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllPurposeOfTheParish() -> [PurposeOfTheParish] {
        return onboardingManager.getAllPurposeOfTheParish()
    }
    
    func set(purposeOfTheParish: PurposeOfTheParish) {
        onboardingManager.set(purposeOfTheParish: purposeOfTheParish)
    }
}
