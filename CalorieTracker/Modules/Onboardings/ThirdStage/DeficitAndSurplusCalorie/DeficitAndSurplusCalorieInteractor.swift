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
    func getDate(rate: Double) -> Date?
    func set(weightGoal: WeightGoal)
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
        guard let currentWeight = onboardingManager.getYourWeight(),
              let targetWeight = onboardingManager.getYourGoalWeight(),
              let gender = onboardingManager.getOnboardingInfo().whatsYourGender?.userSex,
              let age = onboardingManager.getOnboardingInfo().dateOfBirth?.years(to: Date()),
              let height = onboardingManager.getOnboardingInfo().yourHeight
        else { return nil }
        
        let calorieMeasurment = CalorieMeasurment(
            age: age,
            height: height,
            sex: gender,
            weight: currentWeight,
            goalWeight: targetWeight,
            kcalPercent: rate / 100
        )

        let weekGoal = calorieMeasurment.weekGoalKg()
        let weightGoal: WeightGoal = currentWeight >= targetWeight
            ? .loss(calorieDeficit: weekGoal)
            : .gain(calorieSurplus: weekGoal)
        
        onboardingManager.set(weightGoal: weightGoal)
        UDM.kcalGoal = calorieMeasurment.recommendedCalorie
        
        return weightGoal
    }
    
    func getDate(rate: Double) -> Date? {
        guard let currentWeight = onboardingManager.getYourWeight(),
              let targetWeight = onboardingManager.getYourGoalWeight(),
              let gender = onboardingManager.getOnboardingInfo().whatsYourGender?.userSex,
              let age = onboardingManager.getOnboardingInfo().dateOfBirth?.years(to: Date()),
              let height = onboardingManager.getOnboardingInfo().yourHeight
        else { return nil }
        
        let calorieMeasurment = CalorieMeasurment(
            age: age,
            height: height,
            sex: gender,
            weight: currentWeight,
            goalWeight: targetWeight,
            kcalPercent: rate / 100
        )
        
        return calorieMeasurment.goalCompletionDate(Date())
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
    
    func set(weightGoal: WeightGoal) {
        onboardingManager.set(weightGoal: weightGoal)
    }
}
