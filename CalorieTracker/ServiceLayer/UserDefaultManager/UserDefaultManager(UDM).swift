//
//  UDM.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 09.08.2022.
//

import Foundation

final class UDM {
    enum UDMKeys: String {
        case globalIsMetric, weightIsMetric, lengthIsMetric, energyIsMetric
        case liquidCapacityIsMetric, servingWeightIsMetric
        case searchHistory
        case weightGoal, bmiGoal, burnedKcalGoal
        case widgetSettings
        case dailyWaterGoal, dailyStepsGoal
        case isAuthorisedHealthKit, dateHealthKitSync
        case userData
        case startWeight
        case weeklyGoal
        case goalType
        case activityLevel
        case nutrientPercent
        case kcalGoal
        case mealKcalPercent
        case quickAddWaterModels
        case filterTagsTitles
        case exceptionTagsTitles
        case possibleExceptionTags
        case isHapticEnabled
        case currentWorkingDay
    }
    
    static var currentlyWorkingDay: Day {
        get {
            guard let data: Data = getValue(for: .currentWorkingDay),
                   let userData = try? JSONDecoder().decode(Day.self, from: data) else {
                return Day(Date())
            }
            return userData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .currentWorkingDay)
        }
    }
    
    static var isGloballyMetric: Bool {
        get {
            guard let value: Bool = getValue(for: .globalIsMetric) else {
                return true
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .globalIsMetric)
        }
    }
    
    static var weightIsMetric: Bool {
        get {
            guard let value: Bool = getValue(for: .weightIsMetric) else {
                return true
            }
            return value
        }
        
        set {
            if !newValue {
                UDM.isGloballyMetric = false
            }
            setValue(value: newValue, for: .weightIsMetric)
        }
    }
    
    static var lengthIsMetric: Bool {
        get {
            guard let value: Bool = getValue(for: .lengthIsMetric) else {
                return true
            }
            return value
        }
        
        set {
            if !newValue {
                UDM.isGloballyMetric = false
            }
            setValue(value: newValue, for: .lengthIsMetric)
        }
    }
    
    static var energyIsMetric: Bool {
        get {
            guard let value: Bool = getValue(for: .energyIsMetric) else {
                return true
            }
            return value
        }
        
        set {
            if !newValue {
                UDM.isGloballyMetric = false
            }
            setValue(value: newValue, for: .energyIsMetric)
        }
    }
    
    static var liquidCapacityIsMetric: Bool {
        get {
            guard let value: Bool = getValue(for: .liquidCapacityIsMetric) else {
                return true
            }
            return value
        }
        
        set {
            if !newValue {
                UDM.isGloballyMetric = false
            }
            setValue(value: newValue, for: .liquidCapacityIsMetric)
        }
    }
    
    static var servingIsMetric: Bool {
        get {
            guard let value: Bool = getValue(for: .servingWeightIsMetric) else {
                return true
            }
            return value
        }
        
        set {
            if !newValue {
                UDM.isGloballyMetric = false
            }
            setValue(value: newValue, for: .servingWeightIsMetric)
        }
    }
    
    static var isAuthorisedHealthKit: Bool {
        get {
            guard let value: Bool = getValue(for: .isAuthorisedHealthKit) else {
                return false
            }
            return value
        }
        set {
            setValue(value: newValue, for: .isAuthorisedHealthKit)
        }
    }
    
    static var isHapticEnabled: Bool {
        get {
            guard let value: Bool = getValue(for: .isHapticEnabled) else {
                return true
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .isHapticEnabled)
        }
    }
    
    static var dateHealthKitSync: Date? {
        get {
            guard let date: Date = getValue(for: .dateHealthKitSync) else {
                return nil
            }
            return date
        }
        set {
            setValue(value: newValue, for: .dateHealthKitSync)
        }
    }
    
    static var searchHistory: [String] {
        get {
            guard let data: Data = getValue(for: .searchHistory),
                  let value = try? JSONDecoder().decode([String].self, from: data) else {
                return []
            }
            return value
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .searchHistory)
        }
    }
    
    static var weightGoal: Double? {
        get {
            guard let value: Double = getValue(for: .weightGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .weightGoal)
        }
    }
    
    static var weeklyGoal: Double? {
        get {
            guard let value: Double = getValue(for: .weeklyGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .weeklyGoal)
        }
    }
    
    static var bmiGoal: Double? {
        get {
            guard let value: Double = getValue(for: .bmiGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .bmiGoal)
        }
    }
    
    static var startWeight: Double? {
        get {
            guard let value: Double = getValue(for: .startWeight) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .startWeight)
        }
    }
    
    static var kcalGoal: Double? {
        get {
            guard let value: Double = getValue(for: .kcalGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .kcalGoal)
        }
    }
    
    static var widgetSettings: [WidgetType] {
        get {
            guard let data: Data = getValue(for: .widgetSettings),
                   let widgetData = try? JSONDecoder().decode([WidgetType].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .widgetSettings)
        }
    }
    
    static var nutrientPercent: NutrientGoalType? {
        get {
            guard let data: Data = getValue(for: .nutrientPercent),
                   let nutritionData = try? JSONDecoder().decode(NutrientGoalType.self, from: data) else {
                return nil
            }
            return nutritionData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .nutrientPercent)
        }
    }
    
    static var quickAddWaterModels: [QuickAddModel]? {
        get {
            guard let data: Data = getValue(for: .quickAddWaterModels),
                   let waterData = try? JSONDecoder().decode([QuickAddModel].self, from: data) else {
                return nil
            }
            return waterData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .quickAddWaterModels)
        }
    }
    
    static var goalType: GoalType? {
        get {
            guard let data: Data = getValue(for: .goalType),
                   let goalData = try? JSONDecoder().decode(GoalType.self, from: data) else {
                return nil
            }
            return goalData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .goalType)
        }
    }
    
    static var mealKcalPercent: MealKcalPercent {
        get {
            guard let data: Data = getValue(for: .mealKcalPercent),
                   let goalData = try? JSONDecoder().decode(MealKcalPercent.self, from: data) else {
                return .standart
            }
            return goalData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .mealKcalPercent)
        }
    }
    
    static var activityLevel: ActivityLevel? {
        get {
            guard let data: Data = getValue(for: .activityLevel),
                   let activityData = try? JSONDecoder().decode(ActivityLevel.self, from: data) else {
                return nil
            }
            return activityData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .activityLevel)
        }
    }
    
    static var userData: UserData? {
        get {
            guard let data: Data = getValue(for: .userData),
                   let userData = try? JSONDecoder().decode(UserData.self, from: data) else {
                return nil
            }
            return userData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .userData)
        }
    }
    
    static var dailyWaterGoal: Double? {
        get {
            guard let value: Double = getValue(for: .dailyWaterGoal) else {
                return 2000
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .dailyWaterGoal)
        }
    }
    
    static var dailyStepsGoal: Double? {
        get {
            guard let value: Double = getValue(for: .dailyStepsGoal) else {
                return nil
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .dailyStepsGoal)
        }
    }
    
    static var burnedKcalGoal: Double? {
        get {
            guard let value: Double = getValue(for: .burnedKcalGoal) else {
                return nil
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .burnedKcalGoal)
        }
    }
    
    static var titlesForFilterTags: [AdditionalTag.ConvenientTag: String] {
        get {
            guard
                let data: Data = getValue(for: .filterTagsTitles),
                let titles = try? JSONDecoder().decode([AdditionalTag.ConvenientTag: String].self, from: data)  else {
                return [:]
            }
            return titles
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .filterTagsTitles)
        }
    }
    
    static var titlesForExceptionTags: [ExceptionTag.ConvenientExceptionTag: String] {
        get {
            guard
                let data: Data = getValue(for: .exceptionTagsTitles),
                let titles = try? JSONDecoder().decode(
                    [ExceptionTag.ConvenientExceptionTag: String].self,
                    from: data
                )  else {
                return [:]
            }
            return titles
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .exceptionTagsTitles)
        }
    }
    
    static var possibleIngredientsTags: Set<ExceptionTag> {
        get {
            guard
                let data: Data = getValue(for: .possibleExceptionTags),
                let titles = try? JSONDecoder().decode(
                    Set<ExceptionTag> .self,
                    from: data
                )  else {
                return []
            }
            return titles
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .possibleExceptionTags)
        }
    }
}

extension UDM {
    private static func setValue<T>(value: T, for key: UDMKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func getValue<T>(for key: UDMKeys) -> T? {
      UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
