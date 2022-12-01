//
//  StepsWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import Foundation

protocol StepsWidgetServiceInterface {
    func getDailyStepsGoal() -> Double
    func addDailySteps(_ value: Double)
    func setDailyStepsGoal(_ value: Double)
}

final class StepsWidgetService {
    static let shared: StepsWidgetServiceInterface = StepsWidgetService()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension StepsWidgetService: StepsWidgetServiceInterface {
    func getDailyStepsGoal() -> Double {
        UDM.dailyStepsGoal ?? 0
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
