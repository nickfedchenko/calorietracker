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
    func getNameProfile() -> String?
    func getDescriptionProfile() -> String?
    func updateCell(_ type: SettingsCategoryType)
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
    func updateCell(_ type: SettingsCategoryType) {
        view.updateCell(type)
    }
    
    func getNameProfile() -> String? {
        guard let userData = UDM.userData else { return nil }
        let name = userData.name
        let lastName = userData.lastName
        
        return "\(name) \(lastName ?? "")"
    }
    
    func getDescriptionProfile() -> String? {
        guard let userData = UDM.userData else { return nil }
        let sex = userData.sex.getTitle(.long) ?? ""
        let height = BAMeasurement(userData.height, .lenght, isMetric: true).string
        let age = userData.dateOfBirth.years(to: Date()) ?? 0
        
        return "\(sex) ● \(age) years old ● \(height)"
    }
    
    func updateViewController() {
        view.updatePremiumButton(isActiveSubscribe)
    }
    
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func didTapShareButton() {
        let url = URL(string: "http://itunes.com/apps/appname")!
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
        case .sources:
            router?.showSourcesViewController()
        case .contactUs:
            router?.goToWhatsUpPage()
        }
    }
}
