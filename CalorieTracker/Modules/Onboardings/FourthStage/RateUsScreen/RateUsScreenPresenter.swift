//
//  RateUsScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol RateUsScreenPresenterInterface: AnyObject {
    func didTapNextButton()
}

class RateUsScreenPresenter {

    unowned var view: RateUsScreenViewControllerInterface
    let router: RateUsScreenRouterInterface?
    let interactor: RateUsScreenInteractorInterface?

    init(
        interactor: RateUsScreenInteractorInterface,
        router: RateUsScreenRouterInterface,
        view: RateUsScreenViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RateUsScreenPresenter: RateUsScreenPresenterInterface {
    func didTapNextButton() {
        router?.didTapNextButton()
    }
}
