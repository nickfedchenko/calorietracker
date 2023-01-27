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
    func getWeightForDate(_ date: Date) -> Double?
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
    
    func getWeightForDate(_ date: Date) -> Double? {
        let day = Day(date)
        let weightData = localDomainService.fetchWeight()
            .compactMap { $0.day <= day ? $0 : nil }
            .sorted(by: { $0.day > $1.day })
        let weightForDate = weightData.first
        
        return weightForDate?.value
    }
    
    func getStartWeight() -> Double? {
        let weightData = localDomainService.fetchWeight().sorted(by: { $0.day > $1.day })
        let weightStart = weightData.last
        
        return weightStart?.value
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
        let weightData = localDomainService.fetchWeight().sorted(by: { $0.day > $1.day })
        guard let weightStart = weightData.last else { return }
        localDomainService.saveWeight(data: [
            .init(day: weightStart.day, value: value)
        ])
    }
    
    func setWeeklyGoal(_ value: Double) {
        UDM.weeklyGoal = value
    }
}
