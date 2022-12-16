//
//  SettingsRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol SettingsRouterInterface: AnyObject {
    func openChatViewController()
    func openProfileViewController()
    func openGoalsViewController()
    func openAppViewController()
    func openRemindersViewController()
    func openHelpViewController()
    func openRateViewController()
    func closeViewController()
    func openShareViewController(_ url: URL)
    func openPremiumViewController()
}

class SettingsRouter: NSObject {
    
    weak var presenter: SettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> SettingsViewController {
        let vc = SettingsViewController()
        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(interactor: interactor, router: router, view: vc)
        let viewModel = SettingsСategoriesViewModel([
            .profile,
            .chat,
            .goals,
            .app,
            .reminders,
            .rate,
            .help
        ])
        
        vc.viewModel = viewModel
        vc.presenter = presenter
        router.viewController = vc
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension SettingsRouter: SettingsRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func openShareViewController(_ url: URL) {
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        viewController?.present(vc, animated: true)
    }
    
    func openPremiumViewController() {
        
    }
    
    func openProfileViewController() {
        
    }
    
    func openAppViewController() {
        
    }
    
    func openChatViewController() {
        
    }
    
    func openHelpViewController() {
        
    }
    
    func openGoalsViewController() {
        
    }
    
    func openRemindersViewController() {
        
    }
    
    func openRateViewController() {
        
    }
}
