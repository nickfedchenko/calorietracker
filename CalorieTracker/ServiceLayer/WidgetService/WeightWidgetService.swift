//
//  WeightWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import Foundation

protocol WeightWidgetServiceInterface {
    func getWeightGoal() -> Double?
    func addWeight(_ value: Double)
    func setWeightGoal(_ value: Double)
    func getWeightNow() -> Double?
    func getAllWeight() -> [DailyData]
    func getStartWeight() -> Double?
    func getWeeklyGoal() -> Double?
    func setWeeklyGoal(_ value: Double)
    func setStartWeight(_ value: Double)
}

final class WeightWidgetService {
    static let shared: WeightWidgetServiceInterface = WeightWidgetService()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension WeightWidgetService: WeightWidgetServiceInterface {
    func getAllWeight() -> [DailyData] {
        localDomainService.fetchWeight()
    }
    
    func getWeightGoal() -> Double? {
        UDM.weightGoal
    }
    
    func getWeightNow() -> Double? {
        let weightData = localDomainService.fetchWeight().sorted(by: { $0.day > $1.day })
        let weightNow = weightData.first
        
        return weightNow?.value
    }
    
    func getStartWeight() -> Double? {
        UDM.startWeight
    }
    
    func getWeeklyGoal() -> Double? {
        UDM.weeklyGoal
    }
    
    func addWeight(_ value: Double) {
        let dayNow = Day(Date())
        localDomainService.saveWeight(
            data: [
                DailyData(
                    day: dayNow,
                    value: value
                )
            ]
        )
    }
    
    func setWeightGoal(_ value: Double) {
        UDM.weightGoal = value
    }
    
    func setStartWeight(_ value: Double) {
        UDM.startWeight = value
    }
    
    func setWeeklyGoal(_ value: Double) {
        UDM.weeklyGoal = value
    }
}
