//
//  LifeChangesAfterWeightLossInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol LifeChangesAfterWeightLossInteractorInterface: AnyObject {
    func getAllLifeChangesAfterWeightLoss() -> [LifeChangesAfterWeightLoss]
    func set(lifeChangesAfterWeightLoss: LifeChangesAfterWeightLoss)
}

class LifeChangesAfterWeightLossInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: LifeChangesAfterWeightLossPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - LifeChangesAfterWeightLossInteractorInterface

extension LifeChangesAfterWeightLossInteractor: LifeChangesAfterWeightLossInteractorInterface {
    func getAllLifeChangesAfterWeightLoss() -> [LifeChangesAfterWeightLoss] {
        return onboardingManager.getAllLifeChangesAfterWeightLoss()
    }
    
    func set(lifeChangesAfterWeightLoss: LifeChangesAfterWeightLoss) {
        onboardingManager.set(lifeChangesAfterWeightLoss: lifeChangesAfterWeightLoss)
    }
}
    
