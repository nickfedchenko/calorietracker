//
//  GoalsSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import Foundation

protocol NutritionGoalPresenterInterface: AnyObject {
    func didTapBackButton()
    func getGoal() -> String?
    func getStartWeight() -> String?
    func getGoalWeight() -> String?
    func getActivityLevel() -> String?
    func getWeeklyGoal() -> String?
    func getCalorieGoal() -> String?
    func getNutrientGoal() -> String?
    func didTapCell(_ type: GoalsSettingsCategoryType)
    func updateCell(type: GoalsSettingsCategoryType)
    func didChange(value: SettingsCustomizableSliderView.CustomizableSliderViewResult)
}

class NutritionGoalPresenter {
    
    unowned var view: NutritionGoalViewControllerInterface
    let router: NutritionGoalRouterInterface?
    
    init(
        router: NutritionGoalRouterInterface,
        view: NutritionGoalViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension NutritionGoalPresenter: NutritionGoalPresenterInterface {

    func getCalorieGoal() -> String? {
        guard let kcalGoal = UDM.kcalGoal else { return nil }
        return BAMeasurement(kcalGoal, .energy, isMetric: true).string(with: 2)
    }
    
    func getNutrientGoal() -> String? {
        return (UDM.nutrientPercent ?? .default).getTitle(.long)
    }
    
    func getGoal() -> String? {
        return UDM.goalType?.getTitle(.long)
    }
    
    func getStartWeight() -> String? {
        let startWeight = WeightWidgetService.shared.getStartWeight() ?? 0
        return BAMeasurement(startWeight, .weight, isMetric: true).string(with: 2)
    }
    
    func getGoalWeight() -> String? {
        if let  goalWeight = UDM.weightGoal {
            return BAMeasurement(goalWeight, .weight, isMetric: true).string(with: 2)
        } else {
           return R.string.localizable.settingsEmptyCellSet()
        }
    }
    
    func getActivityLevel() -> String? {
        if let activity = UDM.activityLevel {
            return activity.getTitle(.long)
        } else {
            return R.string.localizable.settingsEmptyCellSet()
        }
    }
    
    func getWeeklyGoal() -> String? {
        if let
            weeklyGoal = WeightWidgetService.shared.getWeeklyGoal(),
        weeklyGoal != 0 {
            return BAMeasurement(weeklyGoal, .weight, isMetric: true).string(with: 2)
        } else {
            return R.string.localizable.settingsEmptyCellSet()
        }
    }
    
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func didTapCell(_ type: GoalsSettingsCategoryType) {
        switch type {
        case .title:
            return
        case .goal:
            return
        case .startWeight:
            router?.openEnterStartWeightVC()
        case .weight:
            router?.openEnterGoalWeightVC()
        case .activityLevel:
            router?.showActivityLevelSelector()
        case .weekly:
            router?.openEnterWeeklyGoalVC()
        case .calorie:
            router?.openCalorieGoalVC()
        case .nutrient:
            router?.openNutrientGoalsVC()
        }
    }
    
    func updateCell(type: GoalsSettingsCategoryType) {
        view.updateCell(type)
    }
    
    func didChange(value: SettingsCustomizableSliderView.CustomizableSliderViewResult) {
        switch value {
        case .activityLevel(let selectedLevel, let kcalGoal):
            UDM.activityLevel = selectedLevel
            UDM.kcalGoal = kcalGoal
            updateCell(type: .activityLevel)
            updateCell(type: .calorie)
        case .weeklyGoal(let selectedValueInKG, let kcalGoal):
            if let selectedValueInKG = selectedValueInKG {
                UDM.weeklyGoal = UDM.goalType == .loseWeight ? -selectedValueInKG : selectedValueInKG
                UDM.kcalGoal = kcalGoal
                updateCell(type: .weekly)
                updateCell(type: .calorie)
            }
        }
    }
}
