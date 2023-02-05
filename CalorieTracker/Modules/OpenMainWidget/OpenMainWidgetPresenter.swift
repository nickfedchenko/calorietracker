//
//  OpenMainWidgetPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import Foundation

protocol OpenMainWidgetPresenterInterface: AnyObject {

}

class OpenMainWidgetPresenter {

    unowned var view: OpenMainWidgetViewControllerInterface
    let router: OpenMainWidgetRouterInterface?
    let interactor: OpenMainWidgetInteractorInterface?

    init(
        interactor: OpenMainWidgetInteractorInterface,
        router: OpenMainWidgetRouterInterface,
        view: OpenMainWidgetViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension OpenMainWidgetPresenter: OpenMainWidgetPresenterInterface {

}
