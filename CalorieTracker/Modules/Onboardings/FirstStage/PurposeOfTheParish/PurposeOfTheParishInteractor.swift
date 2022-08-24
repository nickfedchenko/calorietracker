//
//  PurposeOfTheParishInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishInteractorInterface: AnyObject {
    func getAllPurposeOfTheParish() -> [PurposeOfTheParish]
    func set(purposeOfTheParish: PurposeOfTheParish)
}

class PurposeOfTheParishInteractor {
    weak var presenter: PurposeOfTheParishPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension PurposeOfTheParishInteractor: PurposeOfTheParishInteractorInterface {
    func getAllPurposeOfTheParish() -> [PurposeOfTheParish] {
        return onboardingManager.getAllPurposeOfTheParish()
    }
    
    func set(purposeOfTheParish: PurposeOfTheParish) {
        onboardingManager.set(purposeOfTheParish: purposeOfTheParish)
    }
}
