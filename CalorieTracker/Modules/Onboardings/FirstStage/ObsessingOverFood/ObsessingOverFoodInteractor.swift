//
//  ObsessingOverFoodInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ObsessingOverFoodInterctorInterface: AnyObject {
    func getAllObsessingOverFood() -> [ObsessingOverFood]
    func set(obsessingOverFood: ObsessingOverFood)
}

class ObsessingOverFoodInteractor {
    
    // MARK: - Public properties

    weak var presenter: ObsessingOverFoodPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - ObsessingOverFoodInterctorInterface

extension ObsessingOverFoodInteractor: ObsessingOverFoodInterctorInterface {
    func getAllObsessingOverFood() -> [ObsessingOverFood] {
        return onboardingManager.getAllObsessingOverFood()
    }
    
    func set(obsessingOverFood: ObsessingOverFood) {
        onboardingManager.set(obsessingOverFood: obsessingOverFood)
    }
}
