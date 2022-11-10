//
//  MainScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol MainScreenPresenterInterface: AnyObject {
    func didTapAddButton()
}

class MainScreenPresenter {

    unowned var view: MainScreenViewControllerInterface
    let router: MainScreenRouterInterface?
    let interactor: MainScreenInteractorInterface?

    init(
        interactor: MainScreenInteractorInterface,
        router: MainScreenRouterInterface,
        view: MainScreenViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MainScreenPresenter: MainScreenPresenterInterface {
    func didTapAddButton() {
        router?.openAddFoodVC()
    }
}
