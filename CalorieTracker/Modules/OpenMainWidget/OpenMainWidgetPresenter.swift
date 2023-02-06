//
//  OpenMainWidgetPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import Foundation

protocol OpenMainWidgetPresenterInterface: AnyObject {
    func updateDailyMeals()
}

class OpenMainWidgetPresenter {

    unowned var view: OpenMainWidgetViewControllerInterface
    let router: OpenMainWidgetRouterInterface?
    let interactor: OpenMainWidgetInteractorInterface?
    
    private var date: Date

    private let mealTimes: [MealTime] = [
        .breakfast,
        .launch,
        .dinner,
        .snack
    ]
    
    init(
        interactor: OpenMainWidgetInteractorInterface,
        router: OpenMainWidgetRouterInterface,
        view: OpenMainWidgetViewControllerInterface,
        date: Date
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.date = date
    }
    
    private func getTodayDailyMeal(_ mealTime: MealTime) -> DailyMeal {
        let day = self.date.day
        
        guard let dailyMeal = FDS.shared.getAllStoredDailyMeals().first(
            where: { $0.mealTime == mealTime && $0.date == day }
        ) else {
            let emptyDailyMeal = DailyMeal(
                date: day,
                mealTime: mealTime,
                foods: []
            )
            return emptyDailyMeal
        }
        
        return dailyMeal
    }
}

extension OpenMainWidgetPresenter: OpenMainWidgetPresenterInterface {
    func updateDailyMeals() {
        let dailyMeals = mealTimes.map { mealTime in
            getTodayDailyMeal(mealTime)
        }
        
        view.setDailyMeals(dailyMeals)
    }
}
