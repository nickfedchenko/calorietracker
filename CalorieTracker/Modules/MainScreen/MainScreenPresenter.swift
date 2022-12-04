//
//  MainScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol MainScreenPresenterInterface: AnyObject {
    func didTapAddButton()
    func didTapWidget(_ type: WidgetContainerViewController.WidgetType)
    func updateWaterWidgetModel()
    func updateStepsWidget()
    func updateWeightWidget()
    func updateCalendarWidget()
    func updateMessageWidget()
    func updateActivityWidget()
    func updateExersiceWidget()
}

class MainScreenPresenter {

    unowned var view: MainScreenViewControllerInterface
    let router: MainScreenRouterInterface?
    let interactor: MainScreenInteractorInterface?

    init(
        interactor: MainScreenInteractorInterface,
        router: MainScreenRouterInterface,
        view: MainScreenViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MainScreenPresenter: MainScreenPresenterInterface {
    func didTapAddButton() {
        router?.openAddFoodVC()
    }
    
    func didTapWidget(_ type: WidgetContainerViewController.WidgetType) {
        router?.openWidget(type)
    }
    
    func updateWaterWidgetModel() {
        let goal = WaterWidgetService.shared.getDailyWaterGoal()
        let waterNow = WaterWidgetService.shared.getWaterNow()
        
        let model = WaterWidgetNode.Model(
            progress: CGFloat(waterNow / goal),
            waterMl: "\(Int(waterNow)) / \(Int(goal)) ml"
        )
        
        view.setWaterWidgetModel(model)
    }
    
    func updateStepsWidget() {
        let goal = StepsWidgetService.shared.getDailyStepsGoal()
        let now = StepsWidgetService.shared.getStepsNow()
        
        view.setStepsWidget(now: Int(now), goal: goal)
    }
    
    func updateWeightWidget() {
        guard let weightNow = WeightWidgetService.shared.getWeightNow() else {
            view.setWeightWidget(weight: nil)
            return
        }
        view.setWeightWidget(weight: CGFloat(weightNow))
    }
    
    func updateCalendarWidget() {
        let calendarModel: CalendarWidgetNode.Model = .init(
            dateString: "May 12",
            daysStreak: 12
        )
        
        view.setCalendarWidget(calendarModel)
    }
    
    func updateMessageWidget() {
        let message: String = "Have a nice day! Don't forget to track your breakfast "
        
        view.setMessageWidget(message)
    }
    
    func updateActivityWidget() {
        let nutritionDailyGoal = UDM.nutritionDailyGoal ?? .zero
        let nutritionToday = FDS.shared.getNutritionToday().nutrition
        let kcalGoal = nutritionDailyGoal.kcal
        let carbsGoal = nutritionDailyGoal.carbs
        let proteinGoal = nutritionDailyGoal.protein
        let fatGoal = nutritionDailyGoal.fat
        let kcalToday = nutritionToday.kcal
        let carbsToday = nutritionToday.carbs
        let proteinToday = nutritionToday.protein
        let fatToday = nutritionToday.fat
        let model: MainWidgetViewNode.Model = .init(
            text: MainWidgetViewNode.Model.Text(
                firstLine: "\(Int(kcalToday)) / \(Int(kcalGoal)) kcal",
                secondLine: "\(Int(carbsToday)) / \(Int(carbsGoal)) carbs",
                thirdLine: "\(Int(proteinToday)) / \(Int(proteinGoal)) protein",
                fourthLine: "\(Int(fatToday)) / \(Int(fatGoal)) fat",
                excludingBurned: "778",
                includingBurned: "1200"
            ),
            circleData: MainWidgetViewNode.Model.CircleData(
                rings: [
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: fatGoal != 0 ? fatToday / fatGoal : 0,
                        color: R.color.addFood.menu.fat(),
                        title: "F",
                        titleColor: nil,
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: proteinGoal != 0 ? proteinToday / proteinGoal : 0,
                        color: R.color.addFood.menu.protein(),
                        title: "P",
                        titleColor: nil,
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: carbsGoal != 0 ? carbsToday / carbsGoal : 0,
                        color: R.color.addFood.menu.carb(),
                        title: "C",
                        titleColor: .blue,
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: kcalGoal != 0 ? kcalToday / kcalGoal : 0,
                        color: R.color.addFood.menu.kcal(),
                        title: nil,
                        titleColor: nil,
                        image: R.image.mainWidgetViewNode.burned()
                    )
                ]
            )
        )
        
        view.setActivityWidget(model)
    }
    
    func updateExersiceWidget() {
        let model: ExercisesWidgetNode.Model = .init(
            exercises: [
                ExercisesWidgetNode.Model.Exercise(
                    burnedKcal: 240,
                    exerciseType: ExerciseType.basketball
                ),
                ExercisesWidgetNode.Model.Exercise(
                    burnedKcal: 320,
                    exerciseType: ExerciseType.swim
                ),
                ExercisesWidgetNode.Model.Exercise(
                    burnedKcal: 135,
                    exerciseType: ExerciseType.core
                ),
                ExercisesWidgetNode.Model.Exercise(
                    burnedKcal: 100,
                    exerciseType: ExerciseType.boxing
                )
            ],
            progress: 0.7,
            burnedKcal: 772,
            goalBurnedKcal: 900
        )
        
        view.setExersiceWidget(model)
    }
}
