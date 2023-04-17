//
//  RateRequestManager.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 11.04.2023.
//

import StoreKit
import UIKit

final class RateRequestManager {
    enum RateRequestManagerPropertiesKeys: String {
        case initialAddFoodCounter
        case postAddFoodCounter
        case initialAddWeightCounter
        case postAddWeightCounter
        case initialAddWaterCounter
        case postAddWaterCounter
        case initialCreateFoodCounter
        case postCreateFoodCounter
        case initialScanCounter
        case postScanCounter
        case daysCounter
    }
    
    enum RequestManagerUpdateKeys {
        case addFood
        case addWeight
        case addWater
        case createFood
        case scanner
    }
    
    static var shouldAskOpinion: Bool {
        if UDM.didTapToWriteReview {
            return false
        } else {
            guard let
                    days = Calendar.current.dateComponents([.day], from: UDM.didShowAskingOpinionDate, to: Date()).day,
                  abs(days) > 6
            else {
                return false
            }
            return true
        }
    }
    
    static var initialAddFoodCounter: Int {
        get {
            guard let value: Int = getValue(for: .initialAddFoodCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .initialAddFoodCounter)
        }
    }
    
    static var postAddFoodCounter: Int {
        get {
            guard let value: Int = getValue(for: .postAddFoodCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .postAddFoodCounter)
        }
    }
    
    static var initialAddWeightCounter: Int {
        get {
            guard let value: Int = getValue(for: .initialAddWeightCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .initialAddWeightCounter)
        }
    }
    
    static var postAddWeightCounter: Int {
        get {
            guard let value: Int = getValue(for: .postAddWeightCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .postAddWeightCounter)
        }
    }
    
    static var initialAddWaterCounter: Int {
        get {
            guard let value: Int = getValue(for: .initialAddWaterCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .initialAddWaterCounter)
        }
    }
    
    static var postAddWaterCounter: Int {
        get {
            guard let value: Int = getValue(for: .postAddWaterCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .postAddWaterCounter)
        }
    }
    
    static var initialCreateFoodCounter: Int {
        get {
            guard let value: Int = getValue(for: .initialCreateFoodCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .initialCreateFoodCounter)
        }
    }
    
    static var postCreateFoodCounter: Int {
        get {
            guard let value: Int = getValue(for: .postCreateFoodCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .postCreateFoodCounter)
        }
    }
    
    static var initialScanCounter: Int {
        get {
            guard let value: Int = getValue(for: .initialScanCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .initialScanCounter)
        }
    }
    
    static var postScanCounter: Int {
        get {
            guard let value: Int = getValue(for: .postScanCounter) else {
                return 0
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .postScanCounter)
        }
    }
    
    static var daysCounter: Int {
        get {
            guard let value: Int = getValue(for: .daysCounter) else {
                return 7
            }
            return value
        }
        
        set {
            setValue(value: newValue, for: .daysCounter)
        }
    }
    
    static func increment(for key: RequestManagerUpdateKeys) {
        switch key {
        case .addFood:
            if initialAddFoodCounter > 2 {
                postAddFoodCounter += 1
            } else {
                initialAddFoodCounter += 1
            }
        case .addWeight:
            if initialAddWeightCounter > 2 {
                postAddWaterCounter += 1
            } else {
                initialAddWeightCounter += 1
            }
        case .addWater:
            if initialAddWaterCounter > 2 {
                postAddWaterCounter += 1
            } else {
                initialAddWaterCounter += 1
            }
        case .createFood:
            if initialAddFoodCounter > 2 {
                postAddFoodCounter += 1
            } else {
                initialAddFoodCounter += 1
            }
        case .scanner:
            if initialScanCounter > 2 {
                postScanCounter += 1
            } else {
                initialScanCounter += 1
            }
        }
        makeDecision(for: key)
    }
    
    private static func makeDecision(for key:RequestManagerUpdateKeys) {
        var shouldShowRequest: Bool = false
        switch key {
        case .addFood:
            if postAddFoodCounter >= 5 && postAddFoodCounter % 5 == 0 {
                shouldShowRequest = true
            } else if initialAddFoodCounter == 3 && postAddFoodCounter == 0 {
                shouldShowRequest = true
            }
        case .addWeight:
            if postAddWeightCounter >= 5 && postAddWeightCounter % 5 == 0 {
                shouldShowRequest = true
            } else if initialAddWeightCounter == 3 && postAddWeightCounter == 0 {
                shouldShowRequest = true
            }
        case .addWater:
            if postAddWaterCounter >= 5 && postAddWaterCounter % 5 == 0 {
                shouldShowRequest = true
            } else if initialAddWaterCounter == 3 && postAddWaterCounter == 0 {
                shouldShowRequest = true
            }
        case .createFood:
            if postCreateFoodCounter >= 5 && postCreateFoodCounter % 5 == 0 {
                shouldShowRequest = true
            } else if initialCreateFoodCounter == 3 && postCreateFoodCounter == 0 {
                shouldShowRequest = true
            }
        case .scanner:
            if postScanCounter >= 5 && postScanCounter % 5 == 0 {
                shouldShowRequest = true
            } else if initialScanCounter == 3 && postCreateFoodCounter == 0 {
                shouldShowRequest = true
            }
        }
        
        if shouldShowRequest {
            showRequest()
        }
    }
    
    private static func setValue<T>(value: T, for key: RateRequestManagerPropertiesKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func getValue<T>(for key: RateRequestManagerPropertiesKeys) -> T? {
      UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
    private static func showRequest() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }
    
}
