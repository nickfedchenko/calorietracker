//
//  MainScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol MainScreenRouterInterface: AnyObject {

}

class MainScreenRouter: NSObject {

    weak var presenter: MainScreenPresenterInterface?

    static func setupModule() -> MainScreenViewController {
        let vc = MainScreenViewController()
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension MainScreenRouter: MainScreenRouterInterface {

}
