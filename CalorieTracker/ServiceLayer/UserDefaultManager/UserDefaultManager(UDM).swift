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
        case weight, calories, bmi, water, carb, dietary, protein, steps, exercises, active
        case weightGoal, caloriesGoal, bmiGoal, waterGoal, carbGoal, stepsGoal, exercisesGoal, activeGoal
        case widgetSettings
        case nutritionDailyGoal, nutritionDaily
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
    
    static var weight: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .weight),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .weight)
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
    
    static var calories: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .calories),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .calories)
        }
    }
    
    static var caloriesGoal: Double? {
        get {
            guard let value: Double = getValue(for: .caloriesGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .caloriesGoal)
        }
    }

    static var bmi: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .bmi),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .bmi)
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

    static var dietary: [TripleWidgetData] {
        get {
            guard let data: Data = getValue(for: .dietary),
                   let widgetData = try? JSONDecoder().decode([TripleWidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .dietary)
        }
    }
    
    static var carb: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .carb),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .carb)
        }
    }
    
    static var carbGoal: Double? {
        get {
            guard let value: Double = getValue(for: .carbGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .carbGoal)
        }
    }
    
    static var active: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .active),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .active)
        }
    }
    
    static var activeGoal: Double? {
        get {
            guard let value: Double = getValue(for: .activeGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .activeGoal)
        }
    }

    static var exercises: [DoubleWidgetData] {
        get {
            guard let data: Data = getValue(for: .exercises),
                   let widgetData = try? JSONDecoder().decode([DoubleWidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .exercises)
        }
    }
    
    static var exercisesGoal: Double? {
        get {
            guard let value: Double = getValue(for: .exercisesGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .exercisesGoal)
        }
    }

    static var steps: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .steps),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .steps)
        }
    }
    
    static var stepsGoal: Double? {
        get {
            guard let value: Double = getValue(for: .stepsGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .stepsGoal)
        }
    }

    static var water: [WidgetData] {
        get {
            guard let data: Data = getValue(for: .water),
                   let widgetData = try? JSONDecoder().decode([WidgetData].self, from: data) else {
                return []
            }
            return widgetData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .water)
        }
    }
    
    static var waterGoal: Double? {
        get {
            guard let value: Double = getValue(for: .waterGoal) else {
                return nil
            }
            return value
        }
        
        set {
            guard let value = newValue else { return }
            setValue(value: value, for: .waterGoal)
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
    
    static var nutritionDaily: DailyNutrition? {
        get {
            guard let data: Data = getValue(for: .nutritionDaily),
                   let nutritionData = try? JSONDecoder().decode(DailyNutrition.self, from: data) else {
                return nil
            }
            return nutritionData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .nutritionDaily)
        }
    }
    
    static var nutritionDailyGoal: DailyNutrition? {
        get {
            guard let data: Data = getValue(for: .nutritionDailyGoal),
                   let nutritionData = try? JSONDecoder().decode(DailyNutrition.self, from: data) else {
                return nil
            }
            return nutritionData
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(value: data, for: .nutritionDailyGoal)
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
