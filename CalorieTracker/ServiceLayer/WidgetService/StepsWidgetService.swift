//
//  StepsWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import Foundation

protocol StepsWidgetServiceInterface {
    func getDailyStepsGoal() -> Int?
    func addDailySteps(_ value: Double)
    func getStepsNow() -> Double
    func getStepsForDate(_ date: Date) -> Double
    func setDailyStepsGoal(_ value: Double)
    func getAllStepsData() -> [DailyData]
}

final class StepsWidgetService {
    static let shared: StepsWidgetServiceInterface = StepsWidgetService()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension StepsWidgetService: StepsWidgetServiceInterface {
    func getAllStepsData() -> [DailyData] {
        localDomainService.fetchSteps()
    }
    
    func getDailyStepsGoal() -> Int? {
        guard let goal = UDM.dailyStepsGoal else { return nil }
        return Int(goal)
    }
    
    func getStepsNow() -> Double {
        return getStepsForDate(Date())
    }
    
    func getStepsForDate(_ date: Date) -> Double {
        let day = Day(date)
        let stepsData = localDomainService.fetchSteps()
        let stepsForDate = stepsData.first(where: { day == $0.day })
        
        return stepsForDate?.value ?? 0
    }
    
    func addDailySteps(_ value: Double) {
        let dayNow = Day(Date())
        let stepsData = localDomainService.fetchSteps()
        let stepsNow = stepsData.first(where: { dayNow == $0.day })
        localDomainService.saveSteps(
            data: [
                DailyData(
                    day: dayNow,
                    value: (stepsNow?.value ?? 0) + value
                )
            ]
        )
    }
    
    func setDailyStepsGoal(_ value: Double) {
        UDM.dailyStepsGoal = value
    }
}
