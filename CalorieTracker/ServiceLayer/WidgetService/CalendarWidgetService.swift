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
        let nutrition = FDS.shared.getAllNutrition()
            .filter { $0.day.month == month && $0.day.year == year }
        let kcalGoal = FDS.shared.getNutritionGoals()?.kcal ?? 0
        var data: [Day: CalorieCorridor] = [:]
        nutrition.forEach {
            data[$0.day] = $0.nutrition.kcal <= kcalGoal ? .hit : .exceeded
        }
        
        return data
    }
    
    func getStreakDays() -> Int {
        let nutrition = FDS.shared.getAllNutrition().sorted(by: { $0.day > $1.day })
        var count = 0
        var days: Set<Day> = []
        nutrition.forEach {
            days.update(with: $0.day)
        }
        count = days.count
        print("Got streak count of \(count)")
        print("With nutritions \(nutrition)")
        return count
    }
}
