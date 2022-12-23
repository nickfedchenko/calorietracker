//
//  AppSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import Foundation

protocol AppSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func didTapCell(_ type: AppSettingsCategoryType)
}

class AppSettingsPresenter {
    
    unowned var view: AppSettingsViewControllerInterface
    let router: AppSettingsRouterInterface?
    
    init(
        router: AppSettingsRouterInterface,
        view: AppSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension AppSettingsPresenter: AppSettingsPresenterInterface {
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func didTapCell(_ type: AppSettingsCategoryType) {
        switch type {
        case .account:
            return
        case .units:
            router?.openUnitsSettingsVC()
        case .sync:
            return
        case .meal:
            return
        case .about:
            router?.openAboutSettingsVC()
        default:
            return
        }
    }
}
