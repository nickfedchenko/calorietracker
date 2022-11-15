//
//  ProgressRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 07.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation
import UIKit

protocol ProgressRouterInterface: AnyObject {

}

class ProgressRouter: NSObject {

    weak var presenter: ProgressPresenterInterface?

    static func setupModule() -> ProgressViewController {
        let vc = ProgressViewController()
        let interactor = ProgressInteractor()
        let router = ProgressRouter()
        let presenter = ProgressPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension ProgressRouter: ProgressRouterInterface {

}
