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
              let height = onboardingManager.getOnboardingInfo().yourHeight,
              let activity = onboardingManager.getOnboardingInfo().activityLevel
        else { return nil }
        
        let recommendedCalories = CalorieMeasurment.calculationRecommendedCalorieWithoutGoal(
            sex: gender,
            activity: activity,
            age: age,
            height: height,
            weight: currentWeight
        )

        let weekGoal = rate
        let weightGoal: WeightGoal = currentWeight >= targetWeight
            ? .loss(calorieDeficit: weekGoal)
            : .gain(calorieSurplus: weekGoal)
        
        onboardingManager.set(weightGoal: weightGoal)
        UDM.kcalGoal = recommendedCalories + (weekGoal * 1100)
        return weightGoal
    }
    
    func getDate(rate: Double) -> Date? {
        guard let currentWeight = onboardingManager.getYourWeight(),
              let targetWeight = onboardingManager.getYourGoalWeight(),
              let gender = onboardingManager.getOnboardingInfo().whatsYourGender?.userSex,
              let age = onboardingManager.getOnboardingInfo().dateOfBirth?.years(to: Date()),
              let height = onboardingManager.getOnboardingInfo().yourHeight,
              let activity = onboardingManager.getOnboardingInfo().activityLevel
        else { return nil }
        
        let recommendedCalories = CalorieMeasurment.calculationRecommendedCalorieWithoutGoal(
            sex: gender,
            activity: activity,
            age: age,
            height: height,
            weight: currentWeight
        )

        let weekGoal = rate
        let weightGoal: WeightGoal = currentWeight >= targetWeight
            ? .loss(calorieDeficit: weekGoal)
            : .gain(calorieSurplus: weekGoal)
        let weightDiff = abs(currentWeight - targetWeight)
        let totalTargetKcal = weightDiff * 7700
        let dailyTarget = (rate != 0 ? abs(rate) : 0.01) * 1100
        let daysToReach = Int(totalTargetKcal / dailyTarget)
        let targetDate = Calendar.current.date(byAdding: .day, value: daysToReach, to: Date())
        return targetDate
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
