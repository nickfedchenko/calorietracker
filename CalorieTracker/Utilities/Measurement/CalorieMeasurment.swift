//
//  CalorieMeasurment.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import Foundation

struct CalorieMeasurment {
    static func calculationRecommendedCalorie(
        sex: UserSex,
        activity: ActivityLevel,
        age: Int,
        height: Double,
        weight: Double
    ) -> Double {
        let calorie = sex.mainFactor
        + sex.weightFactor * weight
        + sex.heightFactor * height
        - sex.ageFactor * Double(age)
        
        return calorie * activity.factor
    }
}

private extension ActivityLevel {
    var factor: Double {
        switch self {
        case .low:
            return 1.375
        case .moderate:
            return 1.55
        case .high:
            return 1.7
        case .veryHigh:
            return 1.9
        }
    }
}

private extension UserSex {
    var weightFactor: Double {
        switch self {
        case .male:
            return 13.75
        case .famale:
            return 9.563
        }
    }
    
    var heightFactor: Double {
        switch self {
        case .male:
            return 5.003
        case .famale:
            return 1.85
        }
    }
    
    var ageFactor: Double {
        switch self {
        case .male:
            return 6.775
        case .famale:
            return 4.676
        }
    }
    
    var mainFactor: Double {
        switch self {
        case .male:
            return 66.5
        case .famale:
            return 655.1
        }
    }
}
