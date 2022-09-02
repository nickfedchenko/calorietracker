//
//  ImprovingTutritionInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol ImprovingNutritionInteractorInterface: AnyObject {
    func getAllImprovingNutrition() -> [ImprovingNutrition]
    func set(improvingNutrition: ImprovingNutrition)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ImprovingNutritionInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: ImprovingNutritionPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - ImprovingNutritionInteractorInterface

extension ImprovingNutritionInteractor: ImprovingNutritionInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllImprovingNutrition() -> [ImprovingNutrition] {
        return onboardingManager.getAllImprovingNutrition()
    }
    
    func set(improvingNutrition: ImprovingNutrition) {
        onboardingManager.set(improvingNutrition: improvingNutrition)
    }
}
