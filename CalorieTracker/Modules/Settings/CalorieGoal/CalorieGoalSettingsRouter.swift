//
//  CalorieGoalSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

protocol CalorieGoalSettingsRouterInterface: AnyObject {
    func closeViewController()
    func openEnterCalorieGoalVC()
    func openRecalculateAlert(_ newKcal: Double)
    func openDiscardChangesAlert()
    func openMealEnterPercentVC(_ mealTime: MealTime)
}

class CalorieGoalSettingsRouter: NSObject {
    
    weak var presenter: CalorieGoalSettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> CalorieGoalSettingsViewController {
        let vc = CalorieGoalSettingsViewController()
        let router = CalorieGoalSettingsRouter()
        let presenter = CalorieGoalSettingsPresenter(router: router, view: vc)
        let viewModel = CalorieGoalSettingsViewModel(
            types: [
                .title,
                .goal,
                .description,
                .breakfast,
                .lunch,
                .dinner,
                .snacks
            ],
            presenter: presenter
        )
        
        vc.viewModel = viewModel
        vc.presenter = presenter
        router.viewController = vc
        router.presenter = presenter
        return vc
    }
}

extension CalorieGoalSettingsRouter: CalorieGoalSettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openEnterCalorieGoalVC() {
        let vc = KeyboardEnterValueViewController(.standart("CALORIE GOAL"))
        vc.complition = { value in
            self.presenter?.setKcalGoal(value, isMetric: false)
        }
        viewController?.present(vc, animated: true)
    }
    
    func openRecalculateAlert(_ newKcal: Double) {
        let newKcalStr = BAMeasurement(newKcal, .energy, isMetric: true).string
        let alert = UIAlertController(
            title: "Recalculate Calorie Goal",
            message: "Your new calorie goal based on your current settings is \(newKcalStr)",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(
            title: "APPLY",
            style: .default,
            handler: { _ in
                self.presenter?.setKcalGoal(newKcal, isMetric: true)
            }
        ))
        
        alert.addAction(.init(
            title: "CANCEL",
            style: .cancel
        ))
        
        viewController?.present(alert, animated: true)
    }
    
    func openDiscardChangesAlert() {
        let alert = UIAlertController(
            title: "Discard changes?",
            message: "You have unsaved changes in Calorie Goal",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(
            title: "APPLY GOALS",
            style: .default,
            handler: { _ in
                self.presenter?.saveGoals()
            }
        ))
        
        alert.addAction(.init(
            title: "DISCARD",
            style: .cancel,
            handler: { _ in
                self.closeViewController()
            }
        ))
        
        viewController?.present(alert, animated: true)
    }
    
    func openMealEnterPercentVC(_ mealTime: MealTime) {
        let vc = KeyboardEnterValueViewController(.meal(mealTime.getTitle(.short) ?? "", { text in
            guard let value = Double(text),
                  let kcalGoal = self.presenter?.getKcalGoal() else { return "" }
            let kcalValue = value / 100 * kcalGoal
            return BAMeasurement(kcalValue.rounded(), .energy, isMetric: true).string
        }))
        
        vc.complition = { value in
            self.presenter?.setMealKcalPercent(value: value / 100, mealTime: mealTime)
        }
        
        viewController?.present(vc, animated: true)
    }
}
