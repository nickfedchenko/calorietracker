//
//  HealthKitAccessManager.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import UIKit
import HealthKit

enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
    case didFailToAuthorise
}

protocol HealthKitAccessManagerProtocol {
    func askPermission(completion: @escaping (Result<Bool, Error>) -> Void)
    func updateAuthorizationStatus()
}

final class HealthKitAccessManager {
    static let shared: HealthKitAccessManagerProtocol = HealthKitAccessManager()
    private let store = HKHealthStore()
}

// MARK: - HealthKitAccessManagerProtocol

extension HealthKitAccessManager: HealthKitAccessManagerProtocol {
    
    func updateAuthorizationStatus() {
        HealthKitDataManager.shared.getSteps { data in
            UDM.isAuthorisedHealthKit = !data.isEmpty
        }
    }
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable:next function_body_length
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
        
        store.getRequestStatusForAuthorization(
            toShare: [],
            read: healthKitTypesToRead
        ) { [weak self] status, error in
            if let error {
                print(error)
            }
            
            switch status {
            case .unnecessary, .unknown:
                guard let url = URL(string: "x-apple-health://") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
            case .shouldRequest:
                self?.store.requestAuthorization(
                    toShare: nil,
                    read: healthKitTypesToRead
                ) { success, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(success))
                    }
                }
            @unknown default:
                guard let url = URL(string: "x-apple-health://") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
}
