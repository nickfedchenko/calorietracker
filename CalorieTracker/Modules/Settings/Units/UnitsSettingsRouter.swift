//
//  UnitsSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

protocol UnitsSettingsRouterInterface: AnyObject {
    func closeViewController()
}

class UnitsSettingsRouter: NSObject {
    
    weak var presenter: UnitsSettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> UnitsSettingsViewController {
        let vc = UnitsSettingsViewController()
        let router = UnitsSettingsRouter()
        let presenter = UnitsSettingsPresenter(router: router, view: vc)
        let viewModel = UnitsSettingsViewModel(
            types: [
                .title,
                .weight,
                .lenght,
                .energy,
                .liquid,
                .serving
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

extension UnitsSettingsRouter: UnitsSettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
