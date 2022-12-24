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
    }
    
    private func saveUserData() {
        let userSex: UserSex = {
            switch onboardingInfo.whatsYourGender {
            case .male:
                return .male
            case .female:
                return .famale
            default:
                return .male
            }
        }()
        
        let userData: UserData = .init(
            name: onboardingInfo.enterYourName ?? "",
            lastName: nil,
            city: nil,
            sex: userSex,
            dateOfBirth: onboardingInfo.dateOfBirth ?? Date(),
            height: onboardingInfo.yourHeight ?? 0,
            dietary: .classic
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
        WeightWidgetService.shared.addWeight(onboardingInfo.yourWeight ?? 0)
    }
}
