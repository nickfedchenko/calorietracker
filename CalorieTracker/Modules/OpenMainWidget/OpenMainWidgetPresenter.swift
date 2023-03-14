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
    
    private func getDailyMeals() -> [DailyMeal] {
        let day = self.date.day
       let dailyMeal = FDS.shared.getAllStoredDailyMeals()
        let breakfast = dailyMeal.first(where: { $0.mealTime == .breakfast && $0.date == day })
        ?? .init(date: Date().day, mealTime: .breakfast, mealData: [])
        let lunch = dailyMeal.first(where: { $0.mealTime == .launch && $0.date == day })
        ?? .init(date: Date().day, mealTime: .launch, mealData: [])
        let dinner = dailyMeal.first(where: { $0.mealTime == .dinner && $0.date == day })
        ?? .init(date: Date().day, mealTime: .dinner, mealData: [])
        let snack = dailyMeal.first(where: { $0.mealTime == .snack && $0.date == day })
        ?? .init(date: Date().day, mealTime: .snack, mealData: [])
        return [breakfast, lunch, dinner, snack]
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
        let now = Date().timeIntervalSince1970
//        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//            guard let self = self else { return }
            let dailyMeals = self.getDailyMeals()
        let new = Date().timeIntervalSince1970
        print("Кольца открываются \(new - now)")
//            DispatchQueue.main.async { [weak self] in
                self.view.setDailyMeals(dailyMeals)
//            }
          
//        }
    }
    
    func getMainWidgetWidget() -> MainWidgetViewNode.Model {
        let date = date ?? Date()
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
        let burnedKcalFromExercises = ExerciseWidgetServise.shared.getBurnedKcalForDate(date)
        let burnedKCalFromSteps = StepsWidgetService.shared.getStepsNow() * 0.0608
        let includingBurned = kcalGoal + burnedKCalFromSteps + burnedKcalFromExercises - kcalToday
        let includingBurnedInt: Int = includingBurned < 0 ? 0 : Int(includingBurned)
        let model: MainWidgetViewNode.Model = .init(
            text: MainWidgetViewNode.Model.Text(
                firstLine: "\(Int(kcalToday)) / \(Int(kcalGoal)) " + R.string.localizable.kcalShort().uppercased(),
                secondLine: "\(Int(carbsToday)) / \(Int(carbsGoal)) " + R.string.localizable.carbsShort().uppercased(),
                thirdLine: "\(Int(proteinToday)) / \(Int(proteinGoal)) " + R.string.localizable.protein().uppercased(),
                fourthLine: "\(Int(fatToday)) / \(Int(fatGoal)) " + R.string.localizable.fatShort().uppercased(),
                excludingBurned: "\(UInt(kcalGoal - kcalToday < 0 ? 0 : kcalGoal - kcalToday))",
                includingBurned: "\(includingBurnedInt)"
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
