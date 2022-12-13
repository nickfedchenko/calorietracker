//
//  SettingsPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol SettingsPresenterInterface: AnyObject {
    
}

class SettingsPresenter {
    
    unowned var view: SettingsViewControllerInterface
    let router: SettingsRouterInterface?
    let interactor: SettingsInteractorInterface?
    
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
    
}
