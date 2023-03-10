//
//  OnboardingSaveDataService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 24.12.2022.
//

import Foundation

struct OnboardingSaveDataService {
    let onboardingInfo: OnboardingInfo
    
    init(_ info: OnboardingInfo) {
        self.onboardingInfo = info
        saveUserData()
        saveUnitsData()
        saveValueData()
    }
    
    private func saveUserData() {
        let userData: UserData = .init(
            name: onboardingInfo.enterYourName ?? "",
            lastName: nil,
            city: nil,
            sex: onboardingInfo.whatsYourGender?.userSex ?? .male,
            dateOfBirth: onboardingInfo.dateOfBirth ?? Date(),
            height: onboardingInfo.yourHeight ?? 0,
            dietary: onboardingInfo.dietarySetting ?? .classic,
            email: onboardingInfo.mail
        )
        
        UDM.userData = userData
    }
    
    private func saveUnitsData() {
        let isMetric: Bool = {
            switch onboardingInfo.measurementSystem {
            case .metricSystem:
                return true
            case .imperialSystem:
                return false
            default:
                return true
            }
        }()
        
        UDM.energyIsMetric = isMetric
        UDM.lengthIsMetric = isMetric
        UDM.liquidCapacityIsMetric = isMetric
        UDM.servingIsMetric = isMetric
        UDM.weightIsMetric = isMetric
        UDM.isGloballyMetric = isMetric
    }
    
    private func saveValueData() {
        UDM.weightGoal = onboardingInfo.whatIsYourGoalWeight
        WeightWidgetService.shared.addWeight(onboardingInfo.yourWeight ?? 0, to: Date())
        UDM.activityLevel = onboardingInfo.activityLevel
        
        switch onboardingInfo.weightGoal {
        case .gain(let value):
            UDM.goalType = .buildMuscle
            UDM.weeklyGoal = value
        case .loss(let value):
            UDM.goalType = .loseWeight
            UDM.weeklyGoal = -value
        default:
            UDM.goalType = .maintainWeight
            UDM.weeklyGoal = nil
        }
    }
}
