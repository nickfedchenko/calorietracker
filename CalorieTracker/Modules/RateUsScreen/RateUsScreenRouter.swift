//
//  RateUsScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RateUsScreenRouterInterface: AnyObject {

}

class RateUsScreenRouter: NSObject {

    weak var presenter: RateUsScreenPresenterInterface?

    static func setupModule() -> RateUsScreenViewController {
        let vc = RateUsScreenViewController()
        let interactor = RateUsScreenInteractor()
        let router = RateUsScreenRouter()
        let presenter = RateUsScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension RateUsScreenRouter: RateUsScreenRouterInterface {

}