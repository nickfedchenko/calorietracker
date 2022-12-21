//
//  CalorieGoalSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

protocol CalorieGoalSettingsRouterInterface: AnyObject {
    func closeViewController()
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
}

