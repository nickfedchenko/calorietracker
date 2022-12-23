//
//  AppSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import SafariServices
import UIKit

protocol AppSettingsRouterInterface: AnyObject {
    func closeViewController()
    func openUnitsSettingsVC()
    func openAboutSettingsVC()
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
                .units,
                .sync,
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
    
    private func openSafaryUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let safaryVC = SFSafariViewController(url: url)
        viewController?.present(safaryVC, animated: true)
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
    
    func openAboutSettingsVC() {
        openSafaryUrl("https://www.google.ru/")
    }
}
