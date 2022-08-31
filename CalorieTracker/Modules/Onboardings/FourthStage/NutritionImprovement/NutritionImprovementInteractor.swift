//
//  NutritionImprovementInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol NutritionImprovementInteractorInterface: AnyObject {
    func set(nutritionImprovement: Bool)
}

class NutritionImprovementInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: NutritionImprovementPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - NutritionImprovementInteractorInterface

extension NutritionImprovementInteractor: NutritionImprovementInteractorInterface {
    func set(nutritionImprovement: Bool) {
        onboardingManager.set(nutritionImprovement: nutritionImprovement)
    }
}
