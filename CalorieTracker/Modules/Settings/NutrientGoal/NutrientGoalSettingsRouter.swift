//
//  NutrientGoalSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

protocol NutrientGoalSettingsRouterInterface: AnyObject {
    func closeViewController()
}

class NutrientGoalSettingsRouter: NSObject {
    
    weak var presenter: NutrientGoalSettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> NutrientGoalSettingsViewController {
        let vc = NutrientGoalSettingsViewController()
        let router = NutrientGoalSettingsRouter()
        let presenter = NutrientGoalSettingsPresenter(router: router, view: vc)
        let viewModel = NutrientGoalSettingsViewModel(
            types: [
                .title,
                .nutrition,
                .nutritionTitle,
                .carbs,
                .protein,
                .fat
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

extension NutrientGoalSettingsRouter: NutrientGoalSettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
