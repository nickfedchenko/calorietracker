//
//  PlaceOfResidenceInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol PlaceOfResidenceInteractorInterface: AnyObject {
    func getAllPlaceOfResidence() -> [PlaceOfResidence]
    func set(placeOfResidence: PlaceOfResidence)
}

class PlaceOfResidenceInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: PlaceOfResidencePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - PlaceOfResidenceInteractorInterface

extension PlaceOfResidenceInteractor: PlaceOfResidenceInteractorInterface {
    func getAllPlaceOfResidence() -> [PlaceOfResidence] {
        return onboardingManager.getAllPlaceOfResidence()
    }
    
    func set(placeOfResidence: PlaceOfResidence) {
        onboardingManager.set(placeOfResidence: placeOfResidence)
    }
}
