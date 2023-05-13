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
    func isAuthorizated() -> Bool
}

final class HealthKitAccessManager {
    static let shared: HealthKitAccessManagerProtocol = HealthKitAccessManager()
    private let store = HKHealthStore()
}

// MARK: - HealthKitAccessManagerProtocol

extension HealthKitAccessManager: HealthKitAccessManagerProtocol {
    
    func isAuthorizated() -> Bool {
        if let type = HKObjectType.quantityType(forIdentifier: .bodyMass) {
            let status = store.authorizationStatus(for: type)
            switch status {
            case .notDetermined:
                return false
            case .sharingDenied:
                return false
            case .sharingAuthorized:
                return true
            }
        } else {
            return false
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
              let distanceQuantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let weightsQuantityType = HKObjectType.quantityType(forIdentifier: .bodyMass)
        else {
            completion(.failure(HealthkitSetupError.dataTypeNotAvailable))
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            activeEnergyQuantityType,
            basalEnergyQuantityType,
            stepsQuantityType,
            distanceQuantityType,
            workoutQuantityType,
            weightsQuantityType
        ]
        
        let healthKitTypesToShare: Set<HKSampleType> = [
            weightsQuantityType
        ]
        
        store.getRequestStatusForAuthorization(
            toShare: healthKitTypesToShare,
            read: healthKitTypesToRead
        ) { [weak self] status, error in
            if let error {
                print(error)
            }
            
            switch status {
            case .unknown:
                completion(.failure(error ?? ErrorDomain.AFError(error: nil)))
            case .unnecessary:
                completion(.failure(error ?? ErrorDomain.AFError(error: nil)))
            case .shouldRequest:
                self?.store.requestAuthorization(
                    toShare: healthKitTypesToShare,
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
