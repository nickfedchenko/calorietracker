//
//  ProfileSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import Foundation

protocol ProfileSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
}

class ProfileSettingsPresenter {
    
    unowned var view: ProfileSettingsViewControllerInterface
    let router: ProfileSettingsRouterInterface?
    
    init(
        router: ProfileSettingsRouterInterface,
        view: ProfileSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension ProfileSettingsPresenter: ProfileSettingsPresenterInterface {
    func didTapBackButton() {
        router?.closeViewController()
    }
}
