//
//  LastCalorieCountInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol LastCalorieCountInteractorInterface: AnyObject {
    func getAllLastCalorieCount() -> [LastCalorieCount]
    func set(lastCalorieCount: LastCalorieCount)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class LastCalorieCountInteractor {
    
    // MARK: - Public properties

    weak var presenter: LastCalorieCountPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - LastCalorieCountInteractorInterface

extension LastCalorieCountInteractor: LastCalorieCountInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllLastCalorieCount() -> [LastCalorieCount] {
        return onboardingManager.getAllLastCalorieCount()
    }
    
    func set(lastCalorieCount: LastCalorieCount) {
        onboardingManager.set(lastCalorieCount: lastCalorieCount)
    }
}
