//
//  CalorieCountInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CalorieCountInteractorInterface: AnyObject {
    func set(calorieCount: Bool)
}

class CalorieCountInteractor {
    weak var presenter: CalorieCountPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}
        
extension CalorieCountInteractor: CalorieCountInteractorInterface {
    func set(calorieCount: Bool) {
        onboardingManager.set(calorieCount: calorieCount)
    }
}
