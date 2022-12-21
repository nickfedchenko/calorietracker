//
//  SettingsPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import ApphudSDK
import Foundation

protocol SettingsPresenterInterface: AnyObject {
    func didTapCell(_ type: SettingsCategoryType)
    func didTapCloseButton()
    func didTapShareButton()
    func didTapPremiumButton()
    func updateViewController()
}

class SettingsPresenter {
    
    unowned var view: SettingsViewControllerInterface
    let router: SettingsRouterInterface?
    let interactor: SettingsInteractorInterface?
    
    private var isActiveSubscribe: Bool { Apphud.hasActiveSubscription() }
    
    init(
        interactor: SettingsInteractorInterface,
        router: SettingsRouterInterface,
        view: SettingsViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SettingsPresenter: SettingsPresenterInterface {
    func updateViewController() {
        view.updatePremiumButton(isActiveSubscribe)
    }
    
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func didTapShareButton() {
        let url = URL(string: "https://www.youtube.com")!
        router?.openShareViewController(url)
    }
    
    func didTapPremiumButton() {
        router?.openPremiumViewController()
    }
    
    func didTapCell(_ type: SettingsCategoryType) {
        switch type {
        case .profile:
            router?.openProfileViewController()
        case .chat:
            router?.openChatViewController()
        case .goals:
            router?.openGoalsViewController()
        case .app:
            router?.openAppViewController()
        case .reminders:
            router?.openRemindersViewController()
        case .rate:
            router?.openRateViewController()
        case .help:
            router?.openHelpViewController()
        }
    }
}
