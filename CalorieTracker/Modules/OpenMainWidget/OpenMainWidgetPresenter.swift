//
//  OpenMainWidgetPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol OpenMainWidgetPresenterInterface: AnyObject {
    func updateDailyMeals()
    func getMainWidgetWidget() -> MainWidgetViewNode.Model
    func didTapCloseButton()
    func didTapAddButton(_ mealTime: MealTime)
    func didTapFoodCell(_ food: Food)
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
    
    private func getDailyMeal(_ mealTime: MealTime) -> DailyMeal {
        let day = self.date.day
        
        guard let dailyMeal = FDS.shared.getAllStoredDailyMeals().first(
            where: { $0.mealTime == mealTime && $0.date == day }
        ) else {
            let emptyDailyMeal = DailyMeal(
                date: day,
                mealTime: mealTime,
                mealData: []
            )
            return emptyDailyMeal
        }
        
        return dailyMeal
    }
}

extension OpenMainWidgetPresenter: OpenMainWidgetPresenterInterface {
    func didTapFoodCell(_ food: Food) {
        router?.openFoodVC(food)
    }
    
    func didTapAddButton(_ mealTime: MealTime) {
        router?.openAddFoodVC(mealTime)
    }
    
    func didTapCloseButton() {
        router?.closeVC()
    }
    
    func updateDailyMeals() {
        let dailyMeals = mealTimes.map { mealTime in
            getDailyMeal(mealTime)
        }
        
        view.setDailyMeals(dailyMeals)
    }
    
    func getMainWidgetWidget() -> MainWidgetViewNode.Model {
        let nutritionDailyGoal = FDS.shared.getNutritionGoals() ?? .zero
        let nutritionToday = FDS.shared.getNutritionForDate(date).nutrition
        let kcalGoal = nutritionDailyGoal.kcal
        let carbsGoal = NutrientMeasurment.convert(
            value: nutritionDailyGoal.carbs,
            type: .carbs,
            from: .kcal,
            to: .gram
        )
        let proteinGoal = NutrientMeasurment.convert(
            value: nutritionDailyGoal.protein,
            type: .protein,
            from: .kcal,
            to: .gram
        )
        let fatGoal = NutrientMeasurment.convert(
            value: nutritionDailyGoal.fat,
            type: .fat,
            from: .kcal,
            to: .gram
        )
        let carbsToday = nutritionToday.carbs
        let proteinToday = nutritionToday.protein
        let fatToday = nutritionToday.fat
        let kcalToday = nutritionToday.kcal
        let burnedKcalToday = ExerciseWidgetServise.shared.getBurnedKcalForDate(date)
        let model: MainWidgetViewNode.Model = .init(
            text: MainWidgetViewNode.Model.Text(
                firstLine: "\(Int(kcalToday)) / \(Int(kcalGoal)) kcal",
                secondLine: "\(Int(carbsToday)) / \(Int(carbsGoal)) carbs",
                thirdLine: "\(Int(proteinToday)) / \(Int(proteinGoal)) protein",
                fourthLine: "\(Int(fatToday)) / \(Int(fatGoal)) fat",
                excludingBurned: "\(Int(kcalToday - burnedKcalToday))",
                includingBurned: "\(Int(kcalToday))"
            ),
            circleData: MainWidgetViewNode.Model.CircleData(
                rings: [
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: fatGoal != 0 ? fatToday / fatGoal : 0,
                        color: UIColor(hex: "4BE9FF"),
                        title: "F",
                        titleColor: UIColor(hex: "00899C"),
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: proteinGoal != 0 ? proteinToday / proteinGoal : 0,
                        color: UIColor(hex: "4BFF52"),
                        title: "P",
                        titleColor: UIColor(hex: "03B50A"),
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: carbsGoal != 0 ? carbsToday / carbsGoal : 0,
                        color: UIColor(hex: "FFE769"),
                        title: "C",
                        titleColor: UIColor(hex: "B89F1B"),
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: kcalGoal != 0 ? kcalToday / kcalGoal : 0,
                        color: UIColor(hex: "FF764B"),
                        title: nil,
                        titleColor: nil,
                        image: R.image.mainWidgetViewNode.burned()
                    )
                ]
            )
        )
        
        return model
    }
}
