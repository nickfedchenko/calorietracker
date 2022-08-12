//
//  UDM.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 09.08.2022.
//

import Foundation

final class UDM {
    enum UDMKeys: String {
        case globalIsMetric
    }
    
    static var isMetric: Bool {
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
    
    private static func setValue<T>(value: T, for key: UDMKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func getValue<T>(for key: UDMKeys) -> T? {
      UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
}
