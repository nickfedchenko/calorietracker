//
//  ProgressSettingsRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 12.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol ProgressSettingsRouterInterface: AnyObject {

}

class ProgressSettingsRouter: NSObject {

    weak var presenter: ProgressSettingsPresenterInterface?

    static func setupModule() -> ProgressSettingsViewController {
        let vc = ProgressSettingsViewController()
        let interactor = ProgressSettingsInteractor()
        let router = ProgressSettingsRouter()
        let presenter = ProgressSettingsPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension ProgressSettingsRouter: ProgressSettingsRouterInterface {

}
