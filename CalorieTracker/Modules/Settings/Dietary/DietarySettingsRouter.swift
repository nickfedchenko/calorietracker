//
//  DietarySettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

protocol DietarySettingsRouterInterface: AnyObject {
    func closeViewController()
}

class DietarySettingsRouter: NSObject {
    
    weak var presenter: DietarySettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> DietarySettingsViewController {
        let vc = DietarySettingsViewController()
        let router = DietarySettingsRouter()
        let presenter = DietarySettingsPresenter(router: router, view: vc)
        let viewModel = DietarySettingsViewModel(
            types: [
                .title,
                .classic,
                .pescatarian,
                .vegetarian,
                .vegan
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

extension DietarySettingsRouter: DietarySettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
