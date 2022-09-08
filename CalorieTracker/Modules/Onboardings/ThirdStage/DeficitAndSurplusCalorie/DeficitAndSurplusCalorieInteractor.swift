//
//  DeficitAndSurplusCalorieInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 05.09.2022.
//

import Foundation

protocol DeficitAndSurplusCalorieInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
    func getYourGoalWeight() -> Double?
    func getYourWeight() -> Double?
    func getWeightGoal(rate: Double) -> WeightGoal?
}

class DeficitAndSurplusCalorieInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: DeficitAndSurplusCaloriePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    private let weightChartService: WeightChartService
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface, weightChartService: WeightChartService) {
        self.onboardingManager = onboardingManager
        self.weightChartService = weightChartService
    }
}

extension DeficitAndSurplusCalorieInteractor: DeficitAndSurplusCalorieInteractorInterface {
    func getWeightGoal(rate: Double) -> WeightGoal? {
        guard
            let currentWeight = onboardingManager.getYourWeight(),
            let targetWeight = onboardingManager.getYourGoalWeight()
        else { return nil }
        
        return weightChartService.calculateWeightGoal(
            currentWeight: currentWeight,
            targetWeight: targetWeight,
            rate: rate
        )
    }
    
    func getYourGoalWeight() -> Double? {
        return onboardingManager.getYourWeight()
    }
    
    func getYourWeight() -> Double? {
        return onboardingManager.getYourGoalWeight()
    }
    
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
