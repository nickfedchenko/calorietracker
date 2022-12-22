//
//  CalendarWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.12.2022.
//

import Foundation

protocol CalendarWidgetServiceInterface {
    func getCalendarData(year: Int, month: Int) -> [Day: CalorieCorridor]
    func getStreakDays() -> Int
}

final class CalendarWidgetService {
    static let shared: CalendarWidgetServiceInterface = CalendarWidgetService()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension CalendarWidgetService: CalendarWidgetServiceInterface {
    func getCalendarData(year: Int, month: Int) -> [Day: CalorieCorridor] {
        let nutrition = localDomainService.fetchNutrition()
            .filter { $0.day.month == month && $0.day.year == year }
        let kcalGoal = FDS.shared.getNutritionGoals()?.kcal ?? 0
        var data: [Day: CalorieCorridor] = [:]
        nutrition.forEach {
            data[$0.day] = $0.nutrition.kcal <= kcalGoal ? .hit : .exceeded
        }
        
        return data
    }
    
    func getStreakDays() -> Int {
        let nutrition = localDomainService.fetchNutrition().sorted(by: { $0.day > $1.day })
        var count = 0
        nutrition.forEach {
            if $0.nutrition.kcal > 0 {
                count += 1
            } else {
                return
            }
        }
        return count
    }
}
