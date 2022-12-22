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
        weight: Double,
        goal: GoalType = .maintainWeight
    ) -> Double {
        let calorie = sex.mainFactor
        + sex.weightFactor * weight
        + sex.heightFactor * height
        - sex.ageFactor * Double(age)
        
        return calorie * activity.factor * goal.factor
    }
    
    static func checkCalorie(
        kcal: Double,
        sex: UserSex,
        activity: ActivityLevel,
        age: Int,
        height: Double,
        weight: Double,
        goal: GoalType = .maintainWeight
    ) -> Bool {
        let recommendedCalorie = calculationRecommendedCalorie(
            sex: sex,
            activity: activity,
            age: age,
            height: height,
            weight: weight
        )
        
        let percent = 1 - (kcal / recommendedCalorie)
        
        switch goal {
        case .loseWeight:
            return (percent >= -0.31) && (percent < 0.05)
        case .buildMuscle:
            return (percent <= 0.31) && (percent > -0.05)
        case .maintainWeight:
            return abs(percent) <= 0.05
        }
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

private extension GoalType {
    var factor: Double {
        switch self {
        case .loseWeight:
            return 0.7
        case .buildMuscle:
            return 1.3
        case .maintainWeight:
            return 1
        }
    }
}
