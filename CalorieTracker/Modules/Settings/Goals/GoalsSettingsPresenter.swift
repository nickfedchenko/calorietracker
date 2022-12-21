//
//  GoalsSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import Foundation

protocol GoalsSettingsPresenterInterface: AnyObject {
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
}

class GoalsSettingsPresenter {
    
    unowned var view: GoalsSettingsViewControllerInterface
    let router: GoalsSettingsRouterInterface?
    
    init(
        router: GoalsSettingsRouterInterface,
        view: GoalsSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension GoalsSettingsPresenter: GoalsSettingsPresenterInterface {
    func getCalorieGoal() -> String? {
        return ""
    }
    
    func getNutrientGoal() -> String? {
        return (UDM.nutrientPercent ?? .default).getTitle(.long)
    }
    
    func getGoal() -> String? {
        return UDM.goalType?.getTitle(.long)
    }
    
    func getStartWeight() -> String? {
        let startWeight = WeightWidgetService.shared.getStartWeight() ?? 0
        return BAMeasurement(startWeight, .weight).string
    }
    
    func getGoalWeight() -> String? {
        let goalWeight = UDM.weightGoal ?? 0
        return BAMeasurement(goalWeight, .weight).string
    }
    
    func getActivityLevel() -> String? {
        UDM.activityLevel?.getTitle(.long)
    }
    
    func getWeeklyGoal() -> String? {
        let weeklyGoal = WeightWidgetService.shared.getWeeklyGoal() ?? 0
        return BAMeasurement(weeklyGoal, .weight).string
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
            return
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
}
