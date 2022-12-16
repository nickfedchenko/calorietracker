//
//  HealthKitAccessManager.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import Foundation
import HealthKit

enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
    case didFailToAuthorise
}

protocol HealthKitAccessManagerProtocol {
    func askPermission(completion: @escaping (Result<Bool, Error>) -> Void)
}

final class HealthKitAccessManager {
    static let shared: HealthKitAccessManagerProtocol = HealthKitAccessManager()
}

// MARK: - HealthKitAccessManagerProtocol

extension HealthKitAccessManager: HealthKitAccessManagerProtocol {
    func askPermission(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(HealthkitSetupError.notAvailableOnDevice))
            return
        }
        
        let workoutQuantityType = HKObjectType.workoutType()
        guard let activeEnergyQuantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
               let basalEnergyQuantityType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
               let stepsQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount),
               let distanceQuantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else {
            completion(.failure(HealthkitSetupError.dataTypeNotAvailable))
            return
        }

        let healthKitTypesToRead: Set<HKObjectType> = [
            activeEnergyQuantityType,
            basalEnergyQuantityType,
            stepsQuantityType,
            distanceQuantityType,
            workoutQuantityType
        ]
        
        HKHealthStore().requestAuthorization(
            toShare: nil,
            read: healthKitTypesToRead
        ) { success, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(success))
            }
        }
    }
}
