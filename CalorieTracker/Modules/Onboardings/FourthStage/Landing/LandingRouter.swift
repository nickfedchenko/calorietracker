//
//  LandingRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol LandingRouterInterface: AnyObject {

}

class LandingRouter: NSObject {

    weak var presenter: LandingPresenterInterface?

    static func setupModule() -> LandingViewController {
        let vc = LandingViewController()
        let interactor = LandingInteractor()
        let router = LandingRouter()
        let presenter = LandingPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension LandingRouter: LandingRouterInterface {

}