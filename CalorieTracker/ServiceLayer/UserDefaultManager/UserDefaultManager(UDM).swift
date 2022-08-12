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
    
    
    private static func setValue<T>(value: T, for key: UDMKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func getValue<T>(for key: UDMKeys) -> T? {
      UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
