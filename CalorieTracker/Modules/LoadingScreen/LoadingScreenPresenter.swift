//
//  LoadingScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.05.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol LoadingScreenPresenterInterface: AnyObject {
    func viewDidLoad()
    func receivedEventFormLoadingManager(event: LoadingEvents)
    func notifyNeedMainScreen()
}

class LoadingScreenPresenter {

    unowned var view: LoadingScreenViewControllerInterface
    let router: LoadingScreenRouterInterface?
    let interactor: LoadingScreenInteractorInterface?

    init(
        interactor: LoadingScreenInteractorInterface,
        router: LoadingScreenRouterInterface,
        view: LoadingScreenViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension LoadingScreenPresenter: LoadingScreenPresenterInterface {
    func notifyNeedMainScreen() {
        router?.navigateToMainScreen()
    }
    
    func receivedEventFormLoadingManager(event: LoadingEvents) {
        view.updateLoadingStatus(by: event)
    }
    
    func viewDidLoad() {
        interactor?.prepareLoadingManager()
        interactor?.startUpdate()
    }
}
