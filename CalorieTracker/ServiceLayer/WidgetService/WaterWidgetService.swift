//
//  WaterWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.12.2022.
//

import Foundation

protocol WaterWidgetServiceInterface {
    func getAllWaterData() -> [DailyData]
    func getDailyWaterGoal() -> Double
    func addDailyWater(_ value: Double)
    func setDailyWaterGoal(_ value: Double)
    func getWaterNow() -> Double
    func getWaterForDate(_ date: Date) -> Double
}

final class WaterWidgetService {
    static let shared: WaterWidgetServiceInterface = WaterWidgetService()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension WaterWidgetService: WaterWidgetServiceInterface {
    func getAllWaterData() -> [DailyData] {
        localDomainService.fetchWater()
    }
    
    func getDailyWaterGoal() -> Double {
        UDM.dailyWaterGoal ?? 0
    }
    
    func getWaterForDate(_ date: Date) -> Double {
        let day = Day(date)
        let waterData = localDomainService.fetchWater()
        let waterForDate = waterData.first(where: { day == $0.day })
        
        return waterForDate?.value ?? 0
    }
    
    func getWaterNow() -> Double {
        return getWaterForDate(Date())
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
