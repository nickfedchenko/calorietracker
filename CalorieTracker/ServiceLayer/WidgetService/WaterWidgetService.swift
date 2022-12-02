//
//  WaterWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.12.2022.
//

import Foundation

protocol WaterWidgetServiceInterface {
    func getDailyWaterGoal() -> Double
    func addDailyWater(_ value: Double)
    func setDailyWaterGoal(_ value: Double)
    func getWaterNow() -> Double
}

final class WaterWidgetService {
    static let shared: WaterWidgetServiceInterface = WaterWidgetService()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension WaterWidgetService: WaterWidgetServiceInterface {
    func getDailyWaterGoal() -> Double {
        UDM.dailyWaterGoal ?? 0
    }
    
    func getWaterNow() -> Double {
        let dayNow = Day(Date())
        let waterData = localDomainService.fetchWater()
        let waterNow = waterData.first(where: { dayNow == $0.day })
        
        return waterNow?.value ?? 0
    }
    
    func addDailyWater(_ value: Double) {
        let dayNow = Day(Date())
        let waterData = localDomainService.fetchWater()
        let waterNow = waterData.first(where: { dayNow == $0.day })
        localDomainService.saveWater(
            data: [
                DailyData(
                    day: dayNow,
                    value: (waterNow?.value ?? 0) + value
                )
            ]
        )
    }
    
    func setDailyWaterGoal(_ value: Double) {
        UDM.dailyWaterGoal = value
    }
}
