//
//  CalorieGoalSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import Foundation

protocol CalorieGoalSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func didTapResetButton()
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
    func setKcalGoal(_ value: Double)
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
    
    unowned var view: CalorieGoalSettingsViewControllerInterface
    let router: CalorieGoalSettingsRouterInterface?
    
    init(
        router: CalorieGoalSettingsRouterInterface,
        view: CalorieGoalSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension CalorieGoalSettingsPresenter: CalorieGoalSettingsPresenterInterface {
    func didTapResetButton() {

    }
    
    func didTapSaveButton() {
        router?.closeViewController()
    }
    
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func getGoalKcalStr() -> String? {
        guard let kcalGoal = self.kcalGoal else { return nil }
        return BAMeasurement(kcalGoal, .energy, isMetric: true).string
    }
    
    func getLunchGoalKcalStr() -> String? {
        return ""
    }
    
    func getDinnerGoalKcalStr() -> String? {
        return "1900 kcal"
    }
    
    func getSnacksGoalKcalStr() -> String? {
        return "1900 kcal"
    }
    
    func getBreakfastGoalKcalStr() -> String? {
        return "1900 kcal"
    }
    
    func getLunchPercentStr() -> String? {
        return "30%"
    }
    
    func getDinnerPercentStr() -> String? {
        return "30%"
    }
    
    func getSnacksPercentStr() -> String? {
        return "30%"
    }
    
    func getBreakfastPercentStr() -> String? {
        return "30%"
    }
    
    func didTapCell(_ type: CalorieGoalSettingsCategoryType) {
        switch type {
        case .goal:
            router?.openEnterCalorieGoalVC()
        case .breakfast:
            return
        case .lunch:
            return
        case .dinner:
            return
        case .snacks:
            return
        default:
            return
        }
    }
    
    func setKcalGoal(_ value: Double) {
        self.kcalGoal = BAMeasurement(value, .energy).value
    }
}
