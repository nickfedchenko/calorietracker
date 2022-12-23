//
//  CalorieGoalSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import Foundation

protocol CalorieGoalSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func didTapRecalculateButton()
    func didTapSaveButton()
    func didTapCell(_ type: CalorieGoalSettingsCategoryType)
    func getGoalKcalStr() -> String?
    func getBreakfastGoalKcalStr() -> String?
    func getSnacksGoalKcalStr() -> String?
    func getDinnerGoalKcalStr() -> String?
    func getLunchGoalKcalStr() -> String?
    func getBreakfastPercentStr() -> String?
    func getSnacksPercentStr() -> String?
    func getDinnerPercentStr() -> String?
    func getLunchPercentStr() -> String?
    func setKcalGoal(_ value: Double, isMetric: Bool)
    func saveGoals()
    func getKcalGoal() -> Double?
    func setMealKcalPercent(value: Double, mealTime: MealTime)
}

class CalorieGoalSettingsPresenter {
    
    private var kcalGoal: Double? {
        didSet {
            view.updateCell(.goal)
            view.updateCell(.breakfast)
            view.updateCell(.dinner)
            view.updateCell(.lunch)
            view.updateCell(.snacks)
        }
    }
    
    private var mealPercent: MealKcalPercent?
    
    unowned var view: CalorieGoalSettingsViewControllerInterface
    let router: CalorieGoalSettingsRouterInterface?
    
    init(
        router: CalorieGoalSettingsRouterInterface,
        view: CalorieGoalSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
        self.kcalGoal = UDM.kcalGoal
        self.mealPercent = UDM.mealKcalPercent
    }
}

extension CalorieGoalSettingsPresenter: CalorieGoalSettingsPresenterInterface {
    func didTapRecalculateButton() {
        guard let userData = UDM.userData,
        let age = userData.dateOfBirth.years(to: Date()),
        let activity = UDM.activityLevel,
        let weight = WeightWidgetService.shared.getWeightNow(),
        let goal = UDM.goalType else {
            return
        }
        
        let newKcal = CalorieMeasurment.calculationRecommendedCalorie(
            sex: userData.sex,
            activity: activity,
            age: age,
            height: userData.height,
            weight: weight,
            goal: goal
        )
        
        router?.openRecalculateAlert(newKcal)
    }
    
    func didTapSaveButton() {
        self.saveGoals()
    }
    
    func didTapBackButton() {
        if kcalGoal == UDM.kcalGoal && mealPercent == UDM.mealKcalPercent {
            router?.closeViewController()
        } else {
            router?.openDiscardChangesAlert()
        }
    }
    
    func getGoalKcalStr() -> String? {
        guard let kcalGoal = self.kcalGoal else { return nil }
        return BAMeasurement(kcalGoal.rounded(), .energy, isMetric: true).string
    }
    
    func getLunchGoalKcalStr() -> String? {
        guard let lunchPercent = mealPercent?.lunch,
                let kcalGoal = kcalGoal else { return nil }
        return BAMeasurement((lunchPercent * kcalGoal).rounded(), .energy, isMetric: true).string
    }
    
    func getDinnerGoalKcalStr() -> String? {
        guard let dinnerPercent = mealPercent?.dinner,
                let kcalGoal = kcalGoal else { return nil }
        return BAMeasurement((dinnerPercent * kcalGoal).rounded(), .energy, isMetric: true).string
    }
    
    func getSnacksGoalKcalStr() -> String? {
        guard let snacksPercent = mealPercent?.snacks, let kcalGoal = kcalGoal else { return nil }
        return BAMeasurement((snacksPercent * kcalGoal).rounded(), .energy, isMetric: true).string
    }
    
    func getBreakfastGoalKcalStr() -> String? {
        guard let breakfastPercent = mealPercent?.breakfast,
                let kcalGoal = kcalGoal else { return nil }
        return BAMeasurement((breakfastPercent * kcalGoal).rounded(), .energy, isMetric: true).string
    }
    
    func getLunchPercentStr() -> String? {
        guard let lunchPercent = mealPercent?.lunch else { return nil }
        return "\(Int(lunchPercent * 100))%"
    }
    
    func getDinnerPercentStr() -> String? {
        guard let dinnerPercent = mealPercent?.dinner else { return nil }
        return "\(Int(dinnerPercent * 100))%"
    }
    
    func getSnacksPercentStr() -> String? {
        guard let snacksPercent = mealPercent?.snacks else { return nil }
        return "\(Int(snacksPercent * 100))%"
    }
    
    func getBreakfastPercentStr() -> String? {
        guard let breakfastPercent = mealPercent?.breakfast else { return nil }
        return "\(Int(breakfastPercent * 100))%"
    }
    
    func didTapCell(_ type: CalorieGoalSettingsCategoryType) {
        switch type {
        case .goal:
            router?.openEnterCalorieGoalVC()
        case .breakfast:
            router?.openMealEnterPercentVC(.breakfast)
        case .lunch:
            router?.openMealEnterPercentVC(.launch)
        case .dinner:
            router?.openMealEnterPercentVC(.dinner)
        case .snacks:
            router?.openMealEnterPercentVC(.snack)
        default:
            return
        }
    }
    
    func setKcalGoal(_ value: Double, isMetric: Bool = false) {
        guard let userData = UDM.userData,
        let age = userData.dateOfBirth.years(to: Date()),
        let activity = UDM.activityLevel,
        let weight = WeightWidgetService.shared.getWeightNow(),
        let goal = UDM.goalType else {
            return
        }
        
        let metricValue = BAMeasurement(value, .energy, isMetric: isMetric).value
        
        if CalorieMeasurment.checkCalorie(
            kcal: metricValue,
            sex: userData.sex,
            activity: activity,
            age: age,
            height: userData.height,
            weight: weight,
            goal: goal
        ) {
            self.kcalGoal = metricValue
        } else {
            
        }
    }
    
    func setMealKcalPercent(value: Double, mealTime: MealTime) {
        guard let oldMealKcalPercent = mealPercent else { return }

        switch mealTime {
        case .breakfast:
            self.mealPercent = .init(
                breakfast: value,
                lunch: oldMealKcalPercent.lunch,
                dinner: oldMealKcalPercent.dinner,
                snacks: oldMealKcalPercent.snacks
            )
            view.updateCell(.breakfast)
        case .launch:
            self.mealPercent = .init(
                breakfast: oldMealKcalPercent.breakfast,
                lunch: value,
                dinner: oldMealKcalPercent.dinner,
                snacks: oldMealKcalPercent.snacks
            )
            view.updateCell(.lunch)
        case .dinner:
            self.mealPercent = .init(
                breakfast: oldMealKcalPercent.breakfast,
                lunch: oldMealKcalPercent.lunch,
                dinner: value,
                snacks: oldMealKcalPercent.snacks
            )
            view.updateCell(.dinner)
        case .snack:
            self.mealPercent = .init(
                breakfast: oldMealKcalPercent.breakfast,
                lunch: oldMealKcalPercent.lunch,
                dinner: oldMealKcalPercent.dinner,
                snacks: value
            )
            view.updateCell(.snacks)
        }
    }
    
    func saveGoals() {
        UDM.kcalGoal = self.kcalGoal
        UDM.mealKcalPercent = mealPercent ?? .standart
        router?.closeViewController()
    }
    
    func getKcalGoal() -> Double? {
        self.kcalGoal
    }
}
