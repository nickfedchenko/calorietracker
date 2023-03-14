//
//  GoalsSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

protocol GoalsSettingsRouterInterface: AnyObject {
    func closeViewController()
    func openEnterStartWeightVC()
    func openEnterGoalWeightVC()
    func openEnterWeeklyGoalVC()
    func openNutrientGoalsVC()
    func openCalorieGoalVC()
}

class GoalsSettingsRouter: NSObject {
    
    weak var presenter: GoalsSettingsPresenterInterface?
    weak var viewController: UIViewController?
    private var currentlyShowingAlertController: CTAlertController?
    static func setupModule() -> GoalsSettingsViewController {
        let vc = GoalsSettingsViewController()
        let router = GoalsSettingsRouter()
        let presenter = GoalsSettingsPresenter(router: router, view: vc)
        let viewModel = GoalsSettingsViewModel(
            types: [
                .title,
                .goal,
                .startWeight,
                .weight,
//                .activityLevel,
//                .weekly,
//                .calorie,
                .nutrient
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

extension GoalsSettingsRouter: GoalsSettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openEnterStartWeightVC() {
        let vc = KeyboardEnterValueViewController(
            .standart(R.string.localizable.settingsGoalStartWeight().uppercased())
        )
        
        vc.complition = { value in
            WeightWidgetService.shared.setStartWeight(BAMeasurement(value, .weight).value)
            self.presenter?.updateCell(type: .startWeight)
        }
        
        viewController?.present(vc, animated: true)
    }
    
    func openEnterGoalWeightVC() {
        let vc = KeyboardEnterValueViewController(.standart(R.string.localizable.settingsGoalWeight()))
        
        vc.complition = { [weak self] value in
            if abs((WeightWidgetService.shared.getStartWeight() ?? 0) - value) > 1 {
                if value < (WeightWidgetService.shared.getStartWeight() ?? 0) && UDM.goalType != .loseWeight {
                    let alert = CTAlertController(type: .newTargetType(
                        newValue: GoalType.loseWeight.getTitle(.long) ?? "",
                        buttonTypes: [
                            .apply(action: { [weak self] in
                                UDM.goalType = .loseWeight
                                UDM.weightGoal = value
                                self?.presenter?.updateCell(type: .goal)
                                self?.presenter?.updateCell(type: .weight)
                                self?.currentlyShowingAlertController?.dismiss(animated: false)
                            }),
                            .cancel(action: { [weak self] in
                                self?.currentlyShowingAlertController?.dismiss(animated: false)
                            })
                        ])
                    )
                    self?.currentlyShowingAlertController = alert
                    alert.modalPresentationStyle = .overFullScreen
                    self?.viewController?.present(alert, animated: false)
                } else if value > (WeightWidgetService.shared.getStartWeight() ?? 0) && UDM.goalType != .buildMuscle {
                    let alert = CTAlertController(type: .newTargetType(
                        newValue: GoalType.buildMuscle.getTitle(.long) ?? "",
                        buttonTypes: [
                            .apply(action: { [weak self] in
                                UDM.goalType = .buildMuscle
                                UDM.weightGoal = value
                                self?.presenter?.updateCell(type: .weight)
                                self?.presenter?.updateCell(type: .goal)
                                self?.currentlyShowingAlertController?.dismiss(animated: false)
                            }),
                            .cancel(action: { [weak self] in
                                self?.currentlyShowingAlertController?.dismiss(animated: false)
                            })
                        ])
                    )
                    self?.currentlyShowingAlertController = alert
                    alert.modalPresentationStyle = .overFullScreen
                    self?.viewController?.present(alert, animated: false)
                } else {
                    UDM.weightGoal = value
                    self?.presenter?.updateCell(type: .weight)
                }
            } else if abs((WeightWidgetService.shared.getStartWeight() ?? 0) - value)
                        <= 1 && UDM.goalType != .maintainWeight {
                let alert = CTAlertController(type: .newTargetType(
                    newValue: GoalType.maintainWeight.getTitle(.long) ?? "",
                    buttonTypes: [
                        .apply(action: { [weak self] in
                            UDM.goalType = .maintainWeight
                            UDM.weightGoal = value
                            self?.presenter?.updateCell(type: .goal)
                            self?.presenter?.updateCell(type: .weight)
                            self?.currentlyShowingAlertController?.dismiss(animated: false)
                        }),
                        .cancel(action: { [weak self] in
                            self?.currentlyShowingAlertController?.dismiss(animated: false)
                        })
                    ])
                )
                self?.currentlyShowingAlertController = alert
                alert.modalPresentationStyle = .overFullScreen
                self?.viewController?.present(alert, animated: false)
            }
            LoggingService.postEvent(event: .weightsetgoal)
        }
        viewController?.present(vc, animated: true)
    }
    
    func openEnterWeeklyGoalVC() {
        let vc = KeyboardEnterValueViewController(.standart("WEEKLY GOAL"))
        
        vc.complition = { value in
            WeightWidgetService.shared.setWeeklyGoal(BAMeasurement(value, .weight).value)
            self.presenter?.updateCell(type: .weekly)
        }
        
        viewController?.present(vc, animated: true)
    }
    
    func openNutrientGoalsVC() {
        let vc = NutritionGoalRouter.setupModule()
        vc.needUpdate = {
            self.presenter?.updateCell(type: .nutrient)
        }
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openCalorieGoalVC() {
        let vc = CalorieGoalSettingsRouter.setupModule()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
