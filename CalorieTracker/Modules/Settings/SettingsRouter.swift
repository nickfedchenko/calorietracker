//
//  SettingsRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol SettingsRouterInterface: AnyObject {
    
}

class SettingsRouter: NSObject {
    
    weak var presenter: SettingsPresenterInterface?
    
    static func setupModule() -> SettingsViewController {
        let vc = SettingsViewController()
        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(interactor: interactor, router: router, view: vc)
        
        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension SettingsRouter: SettingsRouterInterface {
    
}
