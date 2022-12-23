//
//  AppSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

protocol AppSettingsRouterInterface: AnyObject {
    func closeViewController()
    func openUnitsSettingsVC()
}

class AppSettingsRouter: NSObject {
    
    weak var presenter: AppSettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> AppSettingsViewController {
        let vc = AppSettingsViewController()
        let router = AppSettingsRouter()
        let presenter = AppSettingsPresenter(router: router, view: vc)
        let viewModel = AppSettingsViewModel(
            types: [
                .title,
                .account,
                .units,
                .sync,
                .database,
                .haptic,
                .meal,
                .about
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

extension AppSettingsRouter: AppSettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openUnitsSettingsVC() {
        let vc = UnitsSettingsRouter.setupModule()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
