//
//  OpenMainWidgetRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import Foundation
import UIKit

protocol OpenMainWidgetRouterInterface: AnyObject {

}

class OpenMainWidgetRouter: NSObject {

    weak var presenter: OpenMainWidgetPresenterInterface?

    static func setupModule() -> OpenMainWidgetViewController {
        let vc = OpenMainWidgetViewController()
        let interactor = OpenMainWidgetInteractor()
        let router = OpenMainWidgetRouter()
        let presenter = OpenMainWidgetPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension OpenMainWidgetRouter: OpenMainWidgetRouterInterface {

}