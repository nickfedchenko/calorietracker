//
//  HealthKitDataManager.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import Foundation
import HealthKit

protocol HealthKitDataManagerProtocol {
    func getWorkouts(_ complition: @escaping ([Exercise]) -> Void)
    func getSteps(_ complition: @escaping ([DailyData]) -> Void)
    func getBurnedKcal(_ complition: @escaping ([DailyData]) -> Void)
    func getDistanceWalked(_ complition: @escaping ([DailyData]) -> Void)
    func getWeights(_ completion: @escaping ([DailyData]) -> Void)
    func deleteWeights(at day: Day)
    func addWeight(at day: Day?, value: Double)
}

final class HealthKitDataManager {
    enum Error: Swift.Error {
        case commonError
    }
    let healthStore = HKHealthStore()
    static let shared: HealthKitDataManagerProtocol = HealthKitDataManager()

    private func getDailyTotalSteps(completion: @escaping (Result<[DailyData], Error>) -> Void) {
        guard let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return
        }

        let syncDate = UDM.dateHealthKitSync
        let calendar = Calendar.current
        var interval = DateComponents()
        interval.day = 1

        var anchorComponents = calendar.dateComponents(
            [.day, .month, .year],
            from: syncDate ?? Date.distantPast
        )
        anchorComponents.hour = 0
        guard let anchorDate = calendar.date(from: anchorComponents) else { return }

        let stepsQuery = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        stepsQuery.initialResultsHandler = { _, results, _ in
            let endDate = Date() as NSDate
            let startDate = anchorDate
            if let myResults = results {
                var steps: [DailyData] = []
                myResults.enumerateStatistics(from: startDate, to: endDate as Date) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let totalSteps = quantity.doubleValue(for: HKUnit.count())
                        steps.append(.init(day: date.day, value: totalSteps))
                    }
                }
                completion(.success(steps))
            } else {
                completion(.failure(Error.commonError))
            }
        }
        
        healthStore.execute(stepsQuery)
    }
    
    private func getDailyAtciveEnergy(completion: @escaping (Result<[DailyData], Error>) -> Void) {
        guard let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            return
        }

        let calendar = NSCalendar.current
        var interval = DateComponents()
        interval.day = 1
        let syncDate = UDM.dateHealthKitSync
 
        var anchorComponents = calendar.dateComponents(
            [.day, .month, .year], from: Calendar.current.startOfDay(for: Date())
        )
        anchorComponents.hour = 0
        guard let anchorDate = calendar.date(from: anchorComponents) else { return }

        let caloriesQuery = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        caloriesQuery.initialResultsHandler = { _, results, _ in
            let endDate = Date() as NSDate
            let startDate = anchorDate
            if let myResults = results {
                var calories: [DailyData] = []
                myResults.enumerateStatistics(from: startDate, to: endDate as Date) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let totalCalories = quantity.doubleValue(for: HKUnit.kilocalorie())
    
                        calories.append(.init(day: date.day, value: totalCalories))
                    }
                }
                completion(.success(calories))
            } else {
                completion(.failure(Error.commonError))
            }
        }
        healthStore.execute(caloriesQuery)
    }
    
    private func getDailyDistanceWalked(completion: @escaping (Result<[DailyData], Error>) -> Void) {
        guard let type = HKSampleType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning
        ) else {
            return
        }

        let calendar = NSCalendar.current
        var interval = DateComponents()
        interval.day = 1
        let syncDate = UDM.dateHealthKitSync

        var anchorComponents = calendar.dateComponents(
            [.day, .month, .year],
            from: syncDate ?? Date.distantPast
        )
        anchorComponents.hour = 0
        guard let anchorDate = calendar.date(from: anchorComponents) else { return }

        let distanceQuery = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        distanceQuery.initialResultsHandler = { _, results, _ in
            let endDate = Date() as NSDate
            let startDate = anchorDate
            if let myResults = results {
                var distances: [DailyData] = []
                myResults.enumerateStatistics(from: startDate, to: endDate as Date) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let totalDistance = quantity.doubleValue(for: HKUnit.mile())
                        distances.append(.init(day: date.day, value: totalDistance))
                    }
                }
                completion(.success(distances))
            } else {
                completion(.failure(Error.commonError))
            }
        }
        
        healthStore.execute(distanceQuery)
    }
    
    // MARK: - Workkout Data
    
    private func getWorkoutData(completion: @escaping (Result<[Exercise], Error>) -> Void) {
        let type = HKObjectType.workoutType()
        let syncDate = UDM.dateHealthKitSync

        let startDate = syncDate ?? Date.distantPast
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        var workouts: [Exercise] = []
        let query = HKSampleQuery(
            sampleType: type,
            predicate: predicate,
            limit: 0,
            sortDescriptors: sortDescriptors
        ) { _, results, _ in
            if let results = results {
                for result in results {
                    if let workout = result as? HKWorkout {
                        workouts.append(Exercise(
                            date: workout.startDate,
                            type: workout.workoutActivityType.name,
                            burnedKcal: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                        ))
                    }
                }
                completion(.success(workouts))
            } else {
                completion(.failure(Error.commonError))
            }
        }
        healthStore.execute(query)
    }
    
    private func getWeights(at specificDate: Day, completion: @escaping (Bool) -> Void) {
        guard
            let type = HKSampleType.quantityType(forIdentifier: .bodyMass),
            let startOfDay = specificDate.date?.resetDate,
            let endOfDay = specificDate.date?.endOfDay else {
            return
        }
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictEndDate
        )
        
        let weightsQuery = HKSampleQuery(
            sampleType: type,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) { _, samples, error in
                samples?.forEach { [weak self] in
                    self?.healthStore.delete($0) { isSuccessful, error in
                        if let error = error {
                            print(error)
                        } else {
                            print(isSuccessful)
                        }
                    }
                }
            }
        healthStore.execute(weightsQuery)
    }
    
    private func getDailyWeights(completion: @escaping (Result<[DailyData], Error>) -> Void) {
       
        guard let type = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }

        let calendar = NSCalendar.current
        var interval = DateComponents()
        interval.day = 1
        let syncDate = UDM.dateHealthKitSync
 
        var anchorComponents = calendar.dateComponents(
            [.day, .month, .year], from: Calendar.current.startOfDay(for: Date())
        )
        anchorComponents.hour = 0
        guard let anchorDate = calendar.date(from: anchorComponents) else { return }

        let caloriesQuery = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: nil,
            options: [.mostRecent],
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        caloriesQuery.initialResultsHandler = { _, results, _ in
            let endDate = Date()
            let startDate = UDM.dateHealthKitSync ?? .distantPast
            if let myResults = results {
                var weights: [DailyData] = []
                myResults.enumerateStatistics(from: startDate, to: anchorDate) { statistics, _ in
                    if let quantity = statistics.mostRecentQuantity(){
                        let date = statistics.startDate
                        let totalWeight = quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
    
                        weights.append(.init(day: date.day, value: totalWeight, isFromHK: true))
                    }
                }
                completion(.success(weights))
            } else {
                completion(.failure(Error.commonError))
            }
        }
        
        healthStore.execute(caloriesQuery)
    }
}

extension HealthKitDataManager: HealthKitDataManagerProtocol {
    func addWeight(at day: Day? = nil, value: Double) {
        guard let type = HKSampleType.quantityType(forIdentifier: .bodyMass) else { return }
        let count = HKQuantity(
            unit: .gramUnit(with: .kilo),
            doubleValue: BAMeasurement(value, .weight, isMetric: UDM.weightIsMetric).value
        )
        
        let sample = HKQuantitySample(type: type, quantity: count, start: day?.date ?? Date(), end: day?.date ?? Date())
        healthStore.save(sample) { isSuccess, error in
            if let error {
                print(error)
                LocalNotificationsManager.performUserNotification(for: .HKNoShareRights)
            } else {
                print(isSuccess)
            }
        }
    }
    
    func deleteWeights(at day: Day) {
        getWeights(at: day) { isSuccessful in
            print("Successfull - \(isSuccessful)")
        }
    }
    
    func  getWeights(_ completion: @escaping ([DailyData]) -> Void) {
        getDailyWeights { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion([])
            }
        }
    }
    
    func getWorkouts(_ complition: @escaping ([Exercise]) -> Void) {
        getWorkoutData { result in
            switch result {
            case .success(let exercises):
                complition(exercises)
            case .failure:
                complition([])
            }
        }
    }
    
    func getSteps(_ complition: @escaping ([DailyData]) -> Void) {
        getDailyTotalSteps { result in
            switch result {
            case .success(let steps):
                complition(steps)
            case .failure:
                complition([])
            }
        }
    }
    
    func getBurnedKcal(_ complition: @escaping ([DailyData]) -> Void) {
        getDailyAtciveEnergy { result in
            switch result {
            case .success(let kcal):
                complition(kcal)
            case .failure:
                complition([])
            }
        }
    }
    
    func getDistanceWalked(_ complition: @escaping ([DailyData]) -> Void) {
        getDailyDistanceWalked { result in
            switch result {
            case .success(let distance):
                complition(distance)
            case .failure:
                complition([])
            }
        }
    }
}
